
USE uninest_db;

-- ---- Admin ----
-- The application creates/repairs the default admin at startup:
-- admin@uninest.com / admin123

-- ---- Landlords ----
INSERT INTO users (name, email, password, phone, role, is_verified) VALUES
('John Owner', 'john@landlord.com',
 '$2a$12$LmN3oP4qR5sT6uV7wX8yZ9aB0cD1eF2gH3iJ4kL5mN6oP7qR8sT9u',
 '9876543210', 'landlord', 1),
('Mary Property', 'mary@landlord.com',
 '$2a$12$LmN3oP4qR5sT6uV7wX8yZ9aB0cD1eF2gH3iJ4kL5mN6oP7qR8sT9u',
 '9876543211', 'landlord', 0);

-- ---- Students ----
INSERT INTO users (name, email, password, phone, role, is_verified) VALUES
('Alice Student', 'alice@student.com',
 '$2a$12$LmN3oP4qR5sT6uV7wX8yZ9aB0cD1eF2gH3iJ4kL5mN6oP7qR8sT9u',
 '9123456789', 'student', 1),
('Bob Student', 'bob@student.com',
 '$2a$12$LmN3oP4qR5sT6uV7wX8yZ9aB0cD1eF2gH3iJ4kL5mN6oP7qR8sT9u',
 '9123456780', 'student', 1);

-- ---- Properties ----
INSERT INTO properties (landlord_id, title, description, location, price, room_type, amenities, status)
SELECT id, 'Cozy Studio Near Campus',
       'Well-furnished studio with high-speed WiFi and 24/7 security. Walking distance to university.',
       'Downtown, City', 8000.00, 'studio', 'WiFi, AC, Laundry, Kitchen, Security', 'approved'
FROM users WHERE email='john@landlord.com';

INSERT INTO properties (landlord_id, title, description, location, price, room_type, amenities, status)
SELECT id, 'Affordable Shared Room',
       'Clean shared accommodation in a friendly environment. All utilities included.',
       'University Area', 4500.00, 'shared', 'WiFi, Fan, Common Kitchen, Water', 'approved'
FROM users WHERE email='john@landlord.com';

INSERT INTO properties (landlord_id, title, description, location, price, room_type, amenities, status)
SELECT id, 'Modern 1BHK Apartment',
       'Fully furnished modern apartment with premium amenities.',
       'West District', 12000.00, 'apartment', 'WiFi, AC, Parking, Gym, Security', 'pending'
FROM users WHERE email='mary@landlord.com';

-- ---- Sample Booking ----
INSERT INTO bookings (student_id, property_id, message, status)
SELECT u.id, p.id,
       'Hi, I am a second year student looking for accommodation near campus. I am responsible and tidy.',
       'accepted'
FROM users u, properties p
WHERE u.email='alice@student.com' AND p.title='Cozy Studio Near Campus';
