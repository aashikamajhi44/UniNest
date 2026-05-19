package dao;

import model.Roommate;
import model.User;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoommateDAO {

    private static final String JOIN =
        "SELECT r.*, s.name AS sender_name, s.email AS sender_email, " +
        "rc.name AS receiver_name, rc.email AS receiver_email, p.title AS property_title " +
        "FROM roommate_requests r " +
        "JOIN users s  ON r.sender_id   = s.id " +
        "JOIN users rc ON r.receiver_id = rc.id " +
        "JOIN properties p ON r.property_id = p.id ";

    /** Send a roommate connection request. Returns generated ID. */
    public int sendRequest(int senderId, int receiverId, int propertyId) throws SQLException {
        String sql = "INSERT INTO roommate_requests (sender_id, receiver_id, property_id) "
                + "SELECT ?, ?, ? "
                + "WHERE ? <> ? "
                + "AND EXISTS (SELECT 1 FROM bookings WHERE student_id = ? AND property_id = ? AND status = 'accepted') "
                + "AND EXISTS (SELECT 1 FROM bookings WHERE student_id = ? AND property_id = ? AND status = 'accepted')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            ps.setInt(3, propertyId);
            ps.setInt(4, senderId);
            ps.setInt(5, receiverId);
            ps.setInt(6, senderId);
            ps.setInt(7, propertyId);
            ps.setInt(8, receiverId);
            ps.setInt(9, propertyId);
            int affected = ps.executeUpdate();
            if (affected == 0) {
                return -1;
            }
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        }
    }

    /** Update request status (accepted | rejected). */
    public boolean updateStatus(int requestId, int receiverId, String status) throws SQLException {
        String sql = "UPDATE roommate_requests SET status = ? WHERE id = ? AND receiver_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, requestId);
            ps.setInt(3, receiverId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Check if a request already exists between two students for a property. */
    public boolean requestExists(int senderId, int receiverId, int propertyId) throws SQLException {
        String sql = "SELECT id FROM roommate_requests "
                + "WHERE ((sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)) "
                + "AND property_id = ? AND status != 'rejected'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            ps.setInt(3, receiverId);
            ps.setInt(4, senderId);
            ps.setInt(5, propertyId);
            return ps.executeQuery().next();
        }
    }

    /** Get all incoming (pending) requests for a user. */
    public List<Roommate> getIncoming(int receiverId) throws SQLException {
        return query(JOIN + "WHERE r.receiver_id = ? AND r.status = 'pending' ORDER BY r.created_at DESC", receiverId);
    }

    /** Get all accepted connections for a user (as sender or receiver). */
    public List<Roommate> getAccepted(int userId) throws SQLException {
        String sql = JOIN + "WHERE (r.sender_id = ? OR r.receiver_id = ?) AND r.status = 'accepted'";
        List<Roommate> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Get list of other tenant Users for a given property (for the roommate browse page). */
    public List<User> getTenantsForProperty(int propertyId, int excludeUserId) throws SQLException {
        String sql = "SELECT u.* FROM bookings b JOIN users u ON b.student_id = u.id " +
                     "WHERE b.property_id = ? AND b.status = 'accepted' AND b.student_id != ?";
        List<User> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, propertyId);
            ps.setInt(2, excludeUserId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                list.add(u);
            }
        }
        return list;
    }

    // ---- Private helpers ----

    private List<Roommate> query(String sql, int param) throws SQLException {
        List<Roommate> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, param);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private Roommate mapRow(ResultSet rs) throws SQLException {
        Roommate r = new Roommate();
        r.setId(rs.getInt("id"));
        r.setSenderId(rs.getInt("sender_id"));
        r.setReceiverId(rs.getInt("receiver_id"));
        r.setPropertyId(rs.getInt("property_id"));
        r.setStatus(rs.getString("status"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setSenderName(rs.getString("sender_name"));
        r.setSenderEmail(rs.getString("sender_email"));
        r.setReceiverName(rs.getString("receiver_name"));
        r.setReceiverEmail(rs.getString("receiver_email"));
        r.setPropertyTitle(rs.getString("property_title"));
        return r;
    }
}
