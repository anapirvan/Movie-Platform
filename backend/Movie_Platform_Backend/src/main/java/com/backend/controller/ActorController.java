package com.backend.controller;

import com.backend.dto.ActorCommentResponse;
import com.backend.dto.ActorFeelingResponse;
import com.backend.dto.ActorListResponse;
import oracle.jdbc.OracleTypes;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/actors")
public class ActorController {

    private final DataSource dataSource;

    public ActorController(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @GetMapping
    public ResponseEntity<?> getTotiActorii() throws SQLException {
        String sql = "{ CALL get_actori(?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            ResultSet rs = (ResultSet) cs.getObject(1);
            List<ActorListResponse> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new ActorListResponse(
                        rs.getLong("actor_id"),
                        rs.getString("nume_complet"),
                        rs.getString("nume_scena"),
                        rs.getDate("data_nastere").toLocalDate(),
                        rs.getLong("nr_filme")
                ));
            }
            return ResponseEntity.ok(result);
        }
    }

    @GetMapping("/{actorId}/feeling")
    public ResponseEntity<?> getSentimentActor(@PathVariable Long actorId) throws SQLException {
        String sql = "{ CALL get_sentiment_pred_actor(?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, actorId);
            cs.registerOutParameter(2, Types.VARCHAR);
            cs.registerOutParameter(3, OracleTypes.CURSOR);

            cs.execute();

            String concluzie = cs.getString(2);

            ResultSet rs = (ResultSet) cs.getObject(3);
            List<ActorCommentResponse> comentarii = new ArrayList<>();
            while (rs.next()) {
                comentarii.add(new ActorCommentResponse(
                        rs.getLong("comentariu_id"),
                        rs.getString("client"),
                        rs.getString("film"),
                        rs.getString("text_comentariu"),
                        rs.getDate("data_comentariu").toLocalDate(),
                        rs.getString("sentiment")
                ));
            }

            return ResponseEntity.ok(new ActorFeelingResponse(concluzie, comentarii));
        }
    }
}
