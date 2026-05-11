package com.backend.controller;

import com.backend.dto.VoteRequest;
import com.backend.dto.VoteResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.sql.DataSource;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

@RestController
@RequestMapping("/api/votes")
@AllArgsConstructor
public class VoteController {

    private final DataSource dataSource;

    @PostMapping
    public ResponseEntity<?> insertVot(@Valid @RequestBody VoteRequest req,
                                       HttpSession session) throws SQLException {
        Long clientId = (Long) session.getAttribute("clientId");

        String sql = "{ CALL insert_vot(?, ?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, clientId);
            cs.setLong(2, req.filmId());
            cs.setInt(3, req.scor());
            cs.registerOutParameter(4, Types.NUMERIC);

            cs.execute();

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new VoteResponse(cs.getLong(4)));
        }
    }

    @PutMapping
    public ResponseEntity<?> updateVot(@Valid @RequestBody VoteRequest req,
                                       HttpSession session) throws SQLException {
        Long clientId = (Long) session.getAttribute("clientId");

        String sql = "{ CALL update_vot(?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, clientId);
            cs.setLong(2, req.filmId());
            cs.setInt(3, req.scor());

            cs.execute();

            return ResponseEntity.ok("Vote has been updated.");
        }
    }
}
