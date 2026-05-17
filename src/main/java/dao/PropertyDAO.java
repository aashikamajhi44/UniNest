package dao;

import model.Property;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PropertyDAO {

    /** Insert a new property listing. Returns generated ID. */
    public int insert(Property p) throws SQLException {
        String sql = "INSERT INTO properties (landlord_id, title, description, location, price, room_type, amenities, image_url) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getLandlordId());
            ps.setString(2, p.getTitle());
            ps.setString(3, p.getDescription());
            ps.setString(4, p.getLocation());
            ps.setBigDecimal(5, p.getPrice());
            ps.setString(6, p.getRoomType());
            ps.setString(7, p.getAmenities());
            ps.setString(8, p.getImageUrl());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        }
    }

    /** Update an existing property (landlord-owned only). */
    public boolean update(Property p) throws SQLException {
        String sql = "UPDATE properties SET title=?, description=?, location=?, price=?, room_type=?, amenities=?, image_url=? WHERE id=? AND landlord_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getTitle());
            ps.setString(2, p.getDescription());
            ps.setString(3, p.getLocation());
            ps.setBigDecimal(4, p.getPrice());
            ps.setString(5, p.getRoomType());
            ps.setString(6, p.getAmenities());
            ps.setString(7, p.getImageUrl());
            ps.setInt(8, p.getId());
            ps.setInt(9, p.getLandlordId());
            return ps.executeUpdate() > 0;
        }
    }

    /** Delete a property (landlord-owned only). */
    public boolean delete(int propertyId, int landlordId) throws SQLException {
        String sql = "DELETE FROM properties WHERE id=? AND landlord_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, propertyId);
            ps.setInt(2, landlordId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Admin: update approval status. */
    public boolean updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE properties SET status=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Find single property by ID (with landlord name). */
    public Property findById(int id) throws SQLException {
        String sql = "SELECT p.*, u.name AS landlord_name FROM properties p JOIN users u ON p.landlord_id = u.id WHERE p.id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    /** Student search: only approved, with optional filters. */
    public List<Property> search(String location, String roomType, String maxPrice) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, u.name AS landlord_name FROM properties p JOIN users u ON p.landlord_id = u.id WHERE p.status = 'approved'");
        List<Object> params = new ArrayList<>();

        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND p.location LIKE ?");
            params.add("%" + location.trim() + "%");
        }
        if (roomType != null && !roomType.trim().isEmpty()) {
            sql.append(" AND p.room_type = ?");
            params.add(roomType.trim());
        }
        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
            sql.append(" AND p.price <= ?");
            params.add(new java.math.BigDecimal(maxPrice.trim()));
        }
        sql.append(" ORDER BY p.created_at DESC");

        List<Property> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** All properties for a landlord's dashboard. */
    public List<Property> getByLandlord(int landlordId) throws SQLException {
        String sql = "SELECT p.*, u.name AS landlord_name FROM properties p JOIN users u ON p.landlord_id = u.id WHERE p.landlord_id = ? ORDER BY p.created_at DESC";
        List<Property> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, landlordId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Admin: get all properties. */
    public List<Property> getAll() throws SQLException {
        String sql = "SELECT p.*, u.name AS landlord_name FROM properties p JOIN users u ON p.landlord_id = u.id ORDER BY p.created_at DESC";
        List<Property> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Count total properties. */
    public int countAll() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM properties");
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Count pending-approval properties. */
    public int countPending() throws SQLException {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM properties WHERE status = 'pending'");
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---- Private mapper ----

    private Property mapRow(ResultSet rs) throws SQLException {
        Property p = new Property();
        p.setId(rs.getInt("id"));
        p.setLandlordId(rs.getInt("landlord_id"));
        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));
        p.setLocation(rs.getString("location"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setRoomType(rs.getString("room_type"));
        p.setAmenities(rs.getString("amenities"));
        p.setImageUrl(rs.getString("image_url"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        try { p.setLandlordName(rs.getString("landlord_name")); } catch (SQLException ignored) {}
        return p;
    }
}
