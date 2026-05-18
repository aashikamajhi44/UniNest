package dao;

import model.User;
import util.DBConnection;
import util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) class for managing user-related
 * database operations such as registration, login,
 * verification, retrieval, and deletion.
 *
 * This class communicates with the users table in the database.
 *
 * @author YourName
 * @version 1.0
 */
public class UserDAO {

    /**
     * Registers a new user into the database.
     *
     * The password is hashed before storing for security purposes.
     *
     * @param user User object containing registration details
     * @return generated user ID if registration is successful,
     *         otherwise -1
     * @throws SQLException if a database access error occurs
     */
    public int register(User user) throws SQLException {
        String sql = "INSERT INTO users (name, email, password, phone, role) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, PasswordUtil.hash(user.getPassword()));
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        }
    }

    /**
     * Authenticates a user using email and password.
     *
     * Retrieves the user by email and verifies the password
     * using PasswordUtil.
     *
     * @param email user's email address
     * @param plainPassword plain text password entered by user
     * @return User object if authentication is successful,
     *         otherwise null
     * @throws SQLException if a database access error occurs
     */
    public User login(String email, String plainPassword) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String stored = rs.getString("password");
                if (PasswordUtil.verify(plainPassword, stored)) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    /**
     * Checks whether a given email already exists in the database.
     *
     * @param email email address to check
     * @return true if email exists, otherwise false
     * @throws SQLException if a database access error occurs
     */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        }
    }

    /**
     * Finds a user by their unique ID.
     *
     * @param id user ID
     * @return User object if found, otherwise null
     * @throws SQLException if a database access error occurs
     */
    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    /**
     * Retrieves all users having a specific role.
     *
     * Example roles may include admin, landlord, or tenant.
     *
     * @param role role name to filter users
     * @return list of users matching the role
     * @throws SQLException if a database access error occurs
     */
    public List<User> getAllByRole(String role) throws SQLException {
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";
        List<User> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /**
     * Updates the verification status of a landlord user.
     *
     * @param userId ID of the user
     * @param status verification status to set
     * @return true if update is successful, otherwise false
     * @throws SQLException if a database access error occurs
     */
    public boolean setVerified(int userId, boolean status) throws SQLException {
        String sql = "UPDATE users SET is_verified = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, status ? 1 : 0);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Deletes a user from the database using their ID.
     *
     * @param userId ID of the user to delete
     * @return true if deletion is successful, otherwise false
     * @throws SQLException if a database access error occurs
     */
    public boolean delete(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Counts all non-admin users in the database.
     *
     * @return total number of non-admin users
     * @throws SQLException if a database access error occurs
     */
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role != 'admin'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            return rs.next() ? rs.getInt(1) : 0;
        }
    }


    /**
     * Maps a database ResultSet row into a User object.
     *
     * This method converts database column values
     * into corresponding User object properties.
     *
     * @param rs ResultSet containing user data
     * @return populated User object
     * @throws SQLException if ResultSet access fails
     */
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setVerified(rs.getInt("is_verified") == 1);
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
