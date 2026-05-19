
-- UniNest schema reference for manual database setup.
-- This mirrors the app bootstrap schema in DBConnection.java so the structure is visible here.

CREATE DATABASE IF NOT EXISTS uninest_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE uninest_db;

-- ---- Users ----
CREATE TABLE IF NOT EXISTS users (
    id          INT           AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL,
    email       VARCHAR(150)  NOT NULL UNIQUE,
    password    VARCHAR(255)  NOT NULL,            -- BCrypt hash
    phone       VARCHAR(20),
    role        ENUM('admin','landlord','student') NOT NULL,
    is_verified TINYINT(1)    DEFAULT 0,
    created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_users_role_verified_created (role, is_verified, created_at)
);

-- ---- Properties ----
CREATE TABLE IF NOT EXISTS properties (
    id          INT             AUTO_INCREMENT PRIMARY KEY,
    landlord_id INT             NOT NULL,
    title       VARCHAR(200)    NOT NULL,
    description TEXT,
    location    VARCHAR(255)    NOT NULL,
    price       DECIMAL(10,2)   NOT NULL,
    room_type   ENUM('single','shared','studio','apartment') NOT NULL,
    amenities   TEXT,
    image_url   VARCHAR(500),
    status      ENUM('pending','approved','rejected') DEFAULT 'pending',
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_properties_price CHECK (price >= 0),
    INDEX idx_properties_landlord_created (landlord_id, created_at),
    INDEX idx_properties_status_created (status, created_at),
    INDEX idx_properties_room_type_price (room_type, price),
    FOREIGN KEY (landlord_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ---- Bookings ----
CREATE TABLE IF NOT EXISTS bookings (
    id          INT       AUTO_INCREMENT PRIMARY KEY,
    student_id  INT       NOT NULL,
    property_id INT       NOT NULL,
    message     TEXT,
    status      ENUM('pending','accepted','rejected') DEFAULT 'pending',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_bookings_student_created (student_id, created_at),
    INDEX idx_bookings_property_status (property_id, status, created_at),
    FOREIGN KEY (student_id)  REFERENCES users(id)      ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE
);

-- ---- Roommate Requests ----
CREATE TABLE IF NOT EXISTS roommate_requests (
    id          INT       AUTO_INCREMENT PRIMARY KEY,
    sender_id   INT       NOT NULL,
    receiver_id INT       NOT NULL,
    property_id INT       NOT NULL,
    status      ENUM('pending','accepted','rejected') DEFAULT 'pending',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_roommate_users CHECK (sender_id <> receiver_id),
    UNIQUE KEY  unique_req (sender_id, receiver_id, property_id),
    INDEX idx_roommate_receiver_status (receiver_id, status, created_at),
    INDEX idx_roommate_sender_status (sender_id, status, created_at),
    FOREIGN KEY (sender_id)   REFERENCES users(id)      ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id)      ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE
);

-- ---- Reviews ----
CREATE TABLE IF NOT EXISTS reviews (
    id          INT       AUTO_INCREMENT PRIMARY KEY,
    booking_id  INT       NOT NULL UNIQUE,
    student_id  INT       NOT NULL,
    property_id INT       NOT NULL,
    rating      TINYINT   NOT NULL,
    comment     TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5),
    INDEX idx_reviews_property_created (property_id, created_at),
    INDEX idx_reviews_student_created (student_id, created_at),
    FOREIGN KEY (booking_id)  REFERENCES bookings(id)   ON DELETE CASCADE,
    FOREIGN KEY (student_id)  REFERENCES users(id)      ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE
);

-- ---- Wishlist (saved properties per student) ----
CREATE TABLE IF NOT EXISTS wishlist (
    id          INT       AUTO_INCREMENT PRIMARY KEY,
    student_id  INT       NOT NULL,
    property_id INT       NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY  uniq_wish (student_id, property_id),
    INDEX idx_wishlist_student_created (student_id, created_at),
    FOREIGN KEY (student_id)  REFERENCES users(id)      ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE
);
