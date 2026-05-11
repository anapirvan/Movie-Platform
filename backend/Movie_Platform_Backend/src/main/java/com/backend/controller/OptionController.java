package com.backend.controller;

import com.backend.dto.OptionResponse;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;
import oracle.jdbc.OracleTypes;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api/predifined-options")
public class OptionController {

    private final DataSource dataSource;

    @GetMapping
    public ResponseEntity<?> getOptiuni() throws SQLException {
        String sql = "{ CALL select_optiuni_predefinite(?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            ResultSet rs = (ResultSet) cs.getObject(1);
            List<OptionResponse> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new OptionResponse(
                        rs.getLong("optiune_id"),
                        rs.getString("denumire"),
                        rs.getString("tip")
                ));
            }
            return ResponseEntity.ok(result);
        }
    }



}
