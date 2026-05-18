package dao;

import model.Booking;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    private static final String JOIN =
        "SELECT b.*, u.name AS student_name, p.title AS property_title, p.location AS property_location, "
        + "r.rating AS review_rating, r.comment AS review_comment "
        + "FROM bookings b JOIN users u ON b.student_id = u.id JOIN properties p ON b.property_id = p.id "
        + "LEFT JOIN reviews r ON r.booking_id = b.id ";

    /** Insert a new booking request. Returns generated ID. */
    public int insert(Booking b) throws SQLException {
        String sql = "INSERT INTO bookings (student_id, property_id, message) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, b.getStudentId());
            ps.setInt(2, b.getPropertyId());
            ps.setString(3, b.getMessage());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        }
    }

    /** Update booking status (accepted | rejected). */
    public boolean updateStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Check if a student already has an active booking for a property. */
    public boolean alreadyBooked(int studentId, int propertyId) throws SQLException {
        String sql = "SELECT id FROM bookings WHERE student_id = ? AND property_id = ? AND status != 'rejected'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, propertyId);
            return ps.executeQuery().next();
        }
    }

    /** Get all bookings for a student. */
    public List<Booking> getByStudent(int studentId) throws SQLException {
        return query(JOIN + "WHERE b.student_id = ? ORDER BY b.created_at DESC", studentId);
    }

    /** Get all bookings for all properties owned by a landlord. */
    public List<Booking> getByLandlord(int landlordId) throws SQLException {
        return query(JOIN + "WHERE p.landlord_id = ? ORDER BY b.created_at DESC", landlordId);
    }

    /** Get all bookings for a specific property. */
    public List<Booking> getByProperty(int propertyId) throws SQLException {
        return query(JOIN + "WHERE b.property_id = ? ORDER BY b.created_at DESC", propertyId);
    }

    /** Count total bookings. */
    public int countAll() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM bookings");
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---- Private helpers ----

    private List<Booking> query(String sql, int param) throws SQLException {
        List<Booking> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, param);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private Booking mapRow(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setStudentId(rs.getInt("student_id"));
        b.setPropertyId(rs.getInt("property_id"));
        b.setMessage(rs.getString("message"));
        b.setStatus(rs.getString("status"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setStudentName(rs.getString("student_name"));
        b.setPropertyTitle(rs.getString("property_title"));
        b.setPropertyLocation(rs.getString("property_location"));
        int rating = rs.getInt("review_rating");
        b.setReviewed(!rs.wasNull());
        b.setReviewRating(rating);
        b.setReviewComment(rs.getString("review_comment"));
        return b;
    }
}
