package com.backend.controller;

import com.backend.dto.WatchRequest;
import com.backend.dto.WatchResponse;
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

@RestController
@RequestMapping("/api/watches")
@AllArgsConstructor

public class WatchController {
    private final DataSource dataSource;

    @PostMapping
    public ResponseEntity<?> insertVizualizare(@Valid @RequestBody WatchRequest req,
                                               HttpSession session) throws SQLException {
        Long clientId = (Long) session.getAttribute("clientId");

        String sql = "{ CALL insert_vizualizare(?, ?, ?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, clientId);
            cs.setLong(2, req.versiuneId());
            if (req.durata() != null) {
                cs.setInt(3, req.durata());
            } else {
                cs.setNull(3, Types.NUMERIC);
            }
            cs.setString(4, req.status());
            cs.registerOutParameter(5, Types.NUMERIC);

            cs.execute();

            WatchResponse resp = new WatchResponse(cs.getLong(5));
            return ResponseEntity.status(HttpStatus.CREATED).body(resp);
        }
    }
}