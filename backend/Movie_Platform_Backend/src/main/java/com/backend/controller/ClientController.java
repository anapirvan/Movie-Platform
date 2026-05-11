package com.backend.controller;

import com.backend.dto.*;
import jakarta.servlet.http.HttpSession;
import oracle.jdbc.OracleTypes;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/clients")
public class ClientController {

    private final DataSource dataSource;

    public ClientController(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @GetMapping
    public ResponseEntity<?> getTotiClientii() throws SQLException {
        String sql = "{ CALL get_clienti(?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            ResultSet rs = (ResultSet) cs.getObject(1);
            List<ClientResponse> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new ClientResponse(
                        rs.getLong("client_id"),
                        rs.getString("nume_complet"),
                        rs.getString("email"),
                        rs.getString("telefon"),
                        rs.getString("oras"),
                        rs.getDate("data_inregistrare").toLocalDate(),
                        rs.getLong("nr_vizualizari"),
                        rs.getLong("nr_voturi"),
                        rs.getLong("nr_comentarii")
                ));
            }
            return ResponseEntity.ok(result);
        }
    }

    @GetMapping("/profile")
    public ResponseEntity<?> getProfil(HttpSession session) throws SQLException {
        Long clientId = (Long) session.getAttribute("clientId");

        String sql = "{ CALL get_profil_client(?, ?, ?, ?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, clientId);
            cs.registerOutParameter(2, OracleTypes.CURSOR);
            cs.registerOutParameter(3, OracleTypes.CURSOR);
            cs.registerOutParameter(4, OracleTypes.CURSOR);
            cs.registerOutParameter(5, Types.VARCHAR);

            cs.execute();

            // categorii preferate
            ResultSet rsCat = (ResultSet) cs.getObject(2);
            List<FavoriteCategoryResponse> categorii = new ArrayList<>();
            while (rsCat.next()) {
                categorii.add(new FavoriteCategoryResponse(
                        rsCat.getLong("categorie_id"),
                        rsCat.getString("denumire"),
                        rsCat.getLong("nr_vizualizari")
                ));
            }

            // actori preferati
            ResultSet rsActori = (ResultSet) cs.getObject(3);
            List<FavoriteActorResponse> actori = new ArrayList<>();
            while (rsActori.next()) {
                actori.add(new FavoriteActorResponse(
                        rsActori.getLong("actor_id"),
                        rsActori.getString("nume_complet"),
                        rsActori.getLong("nr_filme_vazute")
                ));
            }

            // istoric
            ResultSet rsIstoric = (ResultSet) cs.getObject(4);
            List<HistoryResponse> istoric = new ArrayList<>();
            while (rsIstoric.next()) {
                istoric.add(new HistoryResponse(
                        rsIstoric.getLong("vizualizare_id"),
                        rsIstoric.getString("titlu"),
                        rsIstoric.getString("format"),
                        rsIstoric.getString("limba"),
                        rsIstoric.getDate("data_vizualizare").toLocalDate(),
                        rsIstoric.getInt("durata_efectiva"),
                        rsIstoric.getString("status")
                ));
            }

            // sentiment dominant
            String sentiment = cs.getString(5);

            return ResponseEntity.ok(new ClientProfileResponse(
                    categorii, actori, istoric, sentiment
            ));
        }
    }

    @GetMapping("/recommandations")
    public ResponseEntity<?> getRecomandari(HttpSession session) throws SQLException {
        Long clientId = (Long) session.getAttribute("clientId");

        String sql = "{ CALL get_recomandari_client(?, ?) }";

        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setLong(1, clientId);
            cs.registerOutParameter(2, OracleTypes.CURSOR);

            cs.execute();

            ResultSet rs = (ResultSet) cs.getObject(2);
            List<RecommandationResponse> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new RecommandationResponse(
                        rs.getLong("film_id"),
                        rs.getString("titlu"),
                        rs.getDouble("rating"),
                        rs.getDate("data_lansare").toLocalDate(),
                        rs.getString("categorii"),
                        rs.getLong("scor_relevanta")
                ));
            }

            return ResponseEntity.ok(result);
        }
    }
}
