package dao;

import model.Wishlist;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class WishlistDAO {

    /** Insert if not exists. Returns true if a new row was created. */
    public boolean add(int studentId, int propertyId) throws SQLException {
        String sql = "INSERT IGNORE INTO wishlist (student_id, property_id) VALUES (?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, propertyId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Remove a single saved property. */
    public boolean remove(int studentId, int propertyId) throws SQLException {
        String sql = "DELETE FROM wishlist WHERE student_id=? AND property_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, propertyId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Toggle helper used by the heart button. Returns the new state (true = wishlisted). */
    public boolean toggle(int studentId, int propertyId) throws SQLException {
        if (isWishlisted(studentId, propertyId)) {
            remove(studentId, propertyId);
            return false;
        }
        add(studentId, propertyId);
        return true;
    }

    public boolean isWishlisted(int studentId, int propertyId) throws SQLException {
        String sql = "SELECT 1 FROM wishlist WHERE student_id=? AND property_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, propertyId);
            return ps.executeQuery().next();
        }
    }

    /** All wishlisted property IDs for a student — handy for marking hearts on grids. */
    public Set<Integer> getPropertyIds(int studentId) throws SQLException {
        Set<Integer> ids = new HashSet<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT property_id FROM wishlist WHERE student_id=?")) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ids.add(rs.getInt(1));
        }
        return ids;
    }

    /** Wishlist with joined property info for the wishlist page. */
    public List<Wishlist> getByStudent(int studentId) throws SQLException {
        String sql = "SELECT w.id, w.student_id, w.property_id, w.created_at, " +
                     "       p.title, p.location, p.price, p.image_url, p.room_type, p.status, " +
                     "       u.name AS landlord_name " +
                     "FROM wishlist w " +
                     "JOIN properties p ON p.id = w.property_id " +
                     "JOIN users u ON u.id = p.landlord_id " +
                     "WHERE w.student_id = ? " +
                     "ORDER BY w.created_at DESC";
        List<Wishlist> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Wishlist w = new Wishlist();
                w.setId(rs.getInt("id"));
                w.setStudentId(rs.getInt("student_id"));
                w.setPropertyId(rs.getInt("property_id"));
                w.setCreatedAt(rs.getTimestamp("created_at"));
                w.setPropertyTitle(rs.getString("title"));
                w.setPropertyLocation(rs.getString("location"));
                w.setPropertyPrice(rs.getBigDecimal("price"));
                w.setPropertyImageUrl(rs.getString("image_url"));
                w.setPropertyRoomType(rs.getString("room_type"));
                w.setPropertyStatus(rs.getString("status"));
                w.setLandlordName(rs.getString("landlord_name"));
                list.add(w);
            }
        }
        return list;
    }

    public Optional<Wishlist> findByStudentAndProperty(int studentId, int propertyId) throws SQLException {
        String sql = "SELECT id, student_id, property_id, created_at FROM wishlist " +
                     "WHERE student_id = ? AND property_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, propertyId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return Optional.empty();
            }
            Wishlist w = new Wishlist();
            w.setId(rs.getInt("id"));
            w.setStudentId(rs.getInt("student_id"));
            w.setPropertyId(rs.getInt("property_id"));
            w.setCreatedAt(rs.getTimestamp("created_at"));
            return Optional.of(w);
        }
    }

    public int countForStudent(int studentId) throws SQLException {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT COUNT(*) FROM wishlist WHERE student_id=?")) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
