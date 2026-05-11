package com.backend.controller;

import com.backend.dto.CommentRequest;
import com.backend.dto.CommentResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/comments")
@AllArgsConstructor
public class CommentController {

    private final DataSource dataSource;

    @PostMapping
    public ResponseEntity<?> insertComment(@Valid @RequestBody CommentRequest req,
                                              HttpSession session) throws SQLException {
        Long clientId = (Long) session.getAttribute("clientId");

        String actorIdsStr = null;
        if (req.actorIds() != null && !req.actorIds().isEmpty()) {
            actorIdsStr = req.actorIds().stream()
                    .map(String::valueOf)
                    .collect(Collectors.joining(","));
        }

        String sql = "{ CALL insert_comentariu(?, ?, ?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, clientId);
            cs.setLong(2, req.filmId());
            cs.setString(3, req.text());
            if (actorIdsStr != null) {
                cs.setString(4, actorIdsStr);
            } else {
                cs.setNull(4, Types.VARCHAR);
            }
            cs.registerOutParameter(5, Types.NUMERIC);

            cs.execute();

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new CommentResponse(cs.getLong(5)));
        }
    }
}
