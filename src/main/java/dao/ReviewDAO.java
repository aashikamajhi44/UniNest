package dao;

import model.Review;
import util.DBConnection;

import java.sql.*;

public class ReviewDAO {

    public boolean canReview(int bookingId, int studentId) throws SQLException {
        String sql = "SELECT id FROM bookings WHERE id = ? AND student_id = ? AND status = 'accepted'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, studentId);
            return ps.executeQuery().next();
        }
    }

    public boolean saveOrUpdate(Review review) throws SQLException {
        String sql = "INSERT INTO reviews (booking_id, student_id, property_id, rating, comment) "
                + "SELECT id, student_id, property_id, ?, ? FROM bookings WHERE id = ? AND student_id = ? AND status = 'accepted' "
                + "ON DUPLICATE KEY UPDATE rating = VALUES(rating), comment = VALUES(comment)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, review.getRating());
            ps.setString(2, review.getComment());
            ps.setInt(3, review.getBookingId());
            ps.setInt(4, review.getStudentId());
            return ps.executeUpdate() > 0;
        }
    }
}

/* attribution: commit by Clauz5568 */
