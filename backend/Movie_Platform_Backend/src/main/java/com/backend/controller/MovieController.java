package com.backend.controller;

import com.backend.dto.*;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import oracle.jdbc.OracleTypes;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.sql.DataSource;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api/movies")
public class MovieController {

    private final DataSource dataSource;

    @GetMapping
    public ResponseEntity<?> getFilme() throws SQLException {
        String sql = "{ CALL get_filme(?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            ResultSet rs = (ResultSet) cs.getObject(1);
            List<MovieResponse> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new MovieResponse(
                        rs.getLong("film_id"),
                        rs.getString("titlu"),
                        rs.getString("descriere"),
                        rs.getDate("data_lansare").toLocalDate(),
                        rs.getDouble("rating"),
                        rs.getString("categorii"),
                        rs.getLong("nr_vizualizari"),
                        rs.getDouble("durata_medie")
                ));
            }
            return ResponseEntity.ok(result);
        }
    }

    @GetMapping("/{filmId}/options")
    public ResponseEntity<?> getOptiuniClientFilm(@PathVariable Long filmId,
                                                  HttpSession session) throws SQLException {
        Long clientId = (Long) session.getAttribute("clientId");
        String sql = "{ CALL select_optiuni_p_client_film(?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, clientId);
            cs.setLong(2, filmId);
            cs.registerOutParameter(3, OracleTypes.CURSOR);
            cs.execute();

            ResultSet rs = (ResultSet) cs.getObject(3);
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

    @PostMapping("/{filmId}/options")
    public ResponseEntity<?> insertOptiune(@PathVariable Long filmId,
                                           @Valid @RequestBody OptionRequest req,
                                           HttpSession session) throws SQLException {
        Long clientId = (Long) session.getAttribute("clientId");
        String sql = "{ CALL insert_optiune_p_client_film(?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, clientId);
            cs.setLong(2, filmId);
            cs.setLong(3, req.optionId());
            cs.execute();

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body("Option has been added.");
        }
    }

    @DeleteMapping("/{filmId}/options/{optionId}")
    public ResponseEntity<?> deleteOptiune(@PathVariable Long filmId,
                                           @PathVariable Long optionId,
                                           HttpSession session) throws SQLException {
        Long clientId = (Long) session.getAttribute("clientId");
        String sql = "{ CALL delete_optiune_p_client_film(?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, clientId);
            cs.setLong(2, filmId);
            cs.setLong(3, optionId);
            cs.execute();

            return ResponseEntity.noContent().build();
        }
    }

    @GetMapping("/{filmId}")
    public ResponseEntity<?> getFilmById(@PathVariable Long filmId) throws SQLException {
        String sql = "{ CALL select_film_by_id(?, ?, ?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, filmId);
            cs.registerOutParameter(2, OracleTypes.CURSOR);
            cs.registerOutParameter(3, OracleTypes.CURSOR);
            cs.registerOutParameter(4, OracleTypes.CURSOR);
            cs.registerOutParameter(5, OracleTypes.CURSOR);
            cs.execute();

            // film general
            ResultSet rsFilm = (ResultSet) cs.getObject(2);
            rsFilm.next();
            String titlu       = rsFilm.getString("titlu");
            String descriere   = rsFilm.getString("descriere");
            LocalDate dataLans = rsFilm.getDate("data_lansare").toLocalDate();
            Double rating      = rsFilm.getDouble("rating");
            String categorii   = rsFilm.getString("categorii");

            // versiuni
            ResultSet rsVers = (ResultSet) cs.getObject(3);
            List<VersionResponse> versiuni = new ArrayList<>();
            while (rsVers.next()) {
                versiuni.add(new VersionResponse(
                        rsVers.getLong("versiune_id"),
                        rsVers.getString("format"),
                        rsVers.getString("limba"),
                        rsVers.getString("rezolutie"),
                        rsVers.getInt("durata_minute")
                ));
            }

            // actori
            ResultSet rsActori = (ResultSet) cs.getObject(4);
            List<ActorResponse> actori = new ArrayList<>();
            while (rsActori.next()) {
                actori.add(new ActorResponse(
                        rsActori.getLong("actor_id"),
                        rsActori.getString("nume_complet"),
                        rsActori.getString("nume_scena"),
                        rsActori.getString("nume_personaj"),
                        rsActori.getString("tip_rol")
                ));
            }

            // comentarii
            ResultSet rsComent = (ResultSet) cs.getObject(5);
            List<CommentDetailResponse> comentarii = new ArrayList<>();
            while (rsComent.next()) {
                comentarii.add(new CommentDetailResponse(
                        rsComent.getLong("comentariu_id"),
                        rsComent.getString("client"),
                        rsComent.getString("text_comentariu"),
                        rsComent.getString("sentiment"),
                        rsComent.getDate("data_comentariu").toLocalDate(),
                        rsComent.getString("actori_mentionati")
                ));
            }

            return ResponseEntity.ok(new MovieDetailResponse(
                    filmId, titlu, descriere, dataLans, rating,
                    categorii, versiuni, actori, comentarii
            ));
        }
    }

    @GetMapping("/{filmId}/feeling")
    public ResponseEntity<?> getSentimentFilm(@PathVariable Long filmId) throws SQLException {
        String sql = "{ CALL get_sentiment_pred_film(?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, filmId);
            cs.registerOutParameter(2, OracleTypes.CURSOR);
            cs.registerOutParameter(3, Types.VARCHAR);

            cs.execute();

            ResultSet rs = (ResultSet) cs.getObject(2);
            List<FeelingSourceResponse> detalii = new ArrayList<>();
            while (rs.next()) {
                detalii.add(new FeelingSourceResponse(
                        rs.getString("sursa"),
                        rs.getLong("pozitiv"),
                        rs.getLong("negativ"),
                        rs.getLong("neutru"),
                        rs.getLong("total")
                ));
            }

            String concluzie = cs.getString(3);

            return ResponseEntity.ok(new MovieFeelingResponse(concluzie, detalii));
        }
    }
}
