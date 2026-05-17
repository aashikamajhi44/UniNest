
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
    created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
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
    UNIQUE KEY  unique_req (sender_id, receiver_id, property_id),
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
    FOREIGN KEY (student_id)  REFERENCES users(id)      ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE
);
