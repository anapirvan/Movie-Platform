package com.backend.controller;

import com.backend.dto.SeasonalStatisticsResponse;
import com.backend.dto.TopSeasonCategoryResponse;
import com.backend.dto.TopSeasonMovieResponse;
import lombok.AllArgsConstructor;
import oracle.jdbc.OracleTypes;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@RestController
@RequestMapping("/api/statistics")
public class StatisticsController {

    private final DataSource dataSource;


    @GetMapping("/seasonal")
    public ResponseEntity<?> getStatisticiSezoniere() throws SQLException {
        String sql = "{ CALL get_statistici_sezoniere(?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.registerOutParameter(2, OracleTypes.CURSOR);

            cs.execute();

            ResultSet rsFilme = (ResultSet) cs.getObject(1);
            List<TopSeasonMovieResponse> topFilme = new ArrayList<>();
            while (rsFilme.next()) {
                topFilme.add(new TopSeasonMovieResponse(
                        rsFilme.getString("sezon"),
                        rsFilme.getLong("film_id"),
                        rsFilme.getString("titlu"),
                        rsFilme.getDouble("rating"),
                        rsFilme.getLong("nr_vizualizari"),
                        rsFilme.getLong("loc_in_sezon")
                ));
            }

            ResultSet rsCategorii = (ResultSet) cs.getObject(2);
            List<TopSeasonCategoryResponse> topCategorii = new ArrayList<>();
            while (rsCategorii.next()) {
                topCategorii.add(new TopSeasonCategoryResponse(
                        rsCategorii.getString("sezon"),
                        rsCategorii.getString("categorie"),
                        rsCategorii.getLong("nr_vizualizari")
                ));
            }

            return ResponseEntity.ok(new SeasonalStatisticsResponse(topFilme, topCategorii));
        }
    }
}
