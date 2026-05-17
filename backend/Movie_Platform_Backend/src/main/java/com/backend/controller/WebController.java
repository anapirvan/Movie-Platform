package com.backend.controller;

import jakarta.servlet.http.HttpSession;
import oracle.jdbc.OracleTypes;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class WebController {

    private final DataSource dataSource;

    public WebController(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        HttpSession session,
                        Model model) {
        String sql = "{ CALL login_client(?, ?) }";
        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setString(1, email);
            cs.registerOutParameter(2, Types.NUMERIC);
            cs.execute();

            session.setAttribute("clientId", cs.getLong(2));
            return "redirect:/filme";

        } catch (SQLException e) {
            model.addAttribute("eroare", "Invalid or non-existent email.");
            return "login";
        }
    }

    @GetMapping("/filme")
    public String filmeePage(Model model) throws SQLException {
        String sql = "{ CALL get_filme(?) }";
        try (Connection conn = dataSource.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            ResultSet rs = (ResultSet) cs.getObject(1);
            List<Map<String, Object>> filme = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> film = new HashMap<>();
                film.put("filmId", rs.getLong("film_id"));
                film.put("titlu", rs.getString("titlu"));
                film.put("rating", rs.getDouble("rating"));
                film.put("categorii", rs.getString("categorii"));
                film.put("dataLansare", rs.getDate("data_lansare").toLocalDate());
                filme.add(film);
            }
            model.addAttribute("filme", filme);
            return "filme";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}