package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_NAME = "uninest_db";
    private static final String DEFAULT_ADMIN_EMAIL = "admin@uninest.com";
    private static final String DEFAULT_ADMIN_PASSWORD = "admin123";
    private static final String BASE_URL = "jdbc:mysql://localhost:3306/?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String URL = "jdbc:mysql://localhost:3306/" + DB_NAME + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // change this if your MySQL root user has a password
    private static boolean initialized = false;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found. Add mysql-connector-java to pom.xml", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        initializeDatabase();
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private static synchronized void initializeDatabase() throws SQLException {
        if (initialized) {
            return;
        }

        try (Connection con = DriverManager.getConnection(BASE_URL, USER, PASSWORD);
             java.sql.Statement st = con.createStatement()) {
            st.executeUpdate("CREATE DATABASE IF NOT EXISTS " + DB_NAME
                    + " CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            st.executeUpdate("USE " + DB_NAME);

            st.executeUpdate("CREATE TABLE IF NOT EXISTS users ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "name VARCHAR(100) NOT NULL,"
                    + "email VARCHAR(150) NOT NULL UNIQUE,"
                    + "password VARCHAR(255) NOT NULL,"
                    + "phone VARCHAR(20),"
                    + "role ENUM('admin','landlord','student') NOT NULL,"
                    + "is_verified TINYINT(1) DEFAULT 0,"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                    + ")");

            st.executeUpdate("CREATE TABLE IF NOT EXISTS properties ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "landlord_id INT NOT NULL,"
                    + "title VARCHAR(200) NOT NULL,"
                    + "description TEXT,"
                    + "location VARCHAR(255) NOT NULL,"
                    + "price DECIMAL(10,2) NOT NULL,"
                    + "room_type ENUM('single','shared','studio','apartment') NOT NULL,"
                    + "amenities TEXT,"
                    + "image_url VARCHAR(500),"
                    + "status ENUM('pending','approved','rejected') DEFAULT 'pending',"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "FOREIGN KEY (landlord_id) REFERENCES users(id) ON DELETE CASCADE"
                    + ")");

            st.executeUpdate("CREATE TABLE IF NOT EXISTS bookings ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "student_id INT NOT NULL,"
                    + "property_id INT NOT NULL,"
                    + "message TEXT,"
                    + "status ENUM('pending','accepted','rejected') DEFAULT 'pending',"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,"
                    + "FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE"
                    + ")");

            st.executeUpdate("CREATE TABLE IF NOT EXISTS roommate_requests ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY,"
                    + "sender_id INT NOT NULL,"
                    + "receiver_id INT NOT NULL,"
                    + "property_id INT NOT NULL,"
                    + "status ENUM('pending','accepted','rejected') DEFAULT 'pending',"
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                    + "UNIQUE KEY unique_req (sender_id, receiver_id, property_id),"
                    + "FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,"
                    + "FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,"
                    + "FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE"
                    + ")");

            ensureDefaultAdmin(con);
        }

        initialized = true;
    }

    private static void ensureDefaultAdmin(Connection con) throws SQLException {
        String passwordHash = PasswordUtil.hash(DEFAULT_ADMIN_PASSWORD);

        String updateSql = "UPDATE users SET name = ?, password = ?, role = 'admin', is_verified = 1 WHERE email = ?";
        try (java.sql.PreparedStatement ps = con.prepareStatement(updateSql)) {
            ps.setString(1, "Super Admin");
            ps.setString(2, passwordHash);
            ps.setString(3, DEFAULT_ADMIN_EMAIL);
            if (ps.executeUpdate() > 0) {
                return;
            }
        }

        String insertSql = "INSERT INTO users (name, email, password, role, is_verified) VALUES (?, ?, ?, 'admin', 1)";
        try (java.sql.PreparedStatement ps = con.prepareStatement(insertSql)) {
            ps.setString(1, "Super Admin");
            ps.setString(2, DEFAULT_ADMIN_EMAIL);
            ps.setString(3, passwordHash);
            ps.executeUpdate();
        }
    }
}
