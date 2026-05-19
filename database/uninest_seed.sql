USE uninest_db;

-- UniNest seed reference
-- The app bootstrap creates admin@uninest.com / admin123 automatically.
-- For the sample rows below, first register one landlord and one student in the app,
-- then change the demo emails here if your local accounts use different addresses.

SET @landlord_email = 'landlord.demo@uninest.com';
SET @student_email  = 'student.demo@uninest.com';

-- Optional: verify the landlord account so booking requests can be created.
UPDATE users
SET is_verified = 1
WHERE email = @landlord_email AND role = 'landlord';

-- Sample approved property
INSERT INTO properties (
    landlord_id, title, description, location, price, room_type, amenities, image_url, status
)
SELECT
    u.id,
    'Sunlit Study Room Near Campus',
    'Quiet room with a dedicated desk, warm lighting, and easy access to classes.',
    'Baneshwor, Kathmandu',
    14500.00,
    'single',
    'WiFi, Study Desk, Laundry, Balcony',
    '/UniNest/images/dashboard-study-corner.png',
    'approved'
FROM users u
WHERE u.email = @landlord_email
  AND u.role = 'landlord'
  AND NOT EXISTS (
      SELECT 1
      FROM properties p
      WHERE p.landlord_id = u.id
        AND p.title = 'Sunlit Study Room Near Campus'
  );

-- Second sample approved property
INSERT INTO properties (
    landlord_id, title, description, location, price, room_type, amenities, image_url, status
)
SELECT
    u.id,
    'Cozy Corner Room with Window View',
    'Bright room with storage, plants, and a calm setup suited for daily student living.',
    'Maitidevi, Kathmandu',
    16800.00,
    'studio',
    'WiFi, Attached Bath, Bookshelf, Printer Access',
    '/UniNest/images/dashboard-cozy-room.png',
    'approved'
FROM users u
WHERE u.email = @landlord_email
  AND u.role = 'landlord'
  AND NOT EXISTS (
      SELECT 1
      FROM properties p
      WHERE p.landlord_id = u.id
        AND p.title = 'Cozy Corner Room with Window View'
  );

-- Sample booking against the first property
INSERT INTO bookings (student_id, property_id, message, status)
SELECT
    s.id,
    p.id,
    'I would like to visit this place this week and confirm availability.',
    'accepted'
FROM users s
JOIN users l
  ON l.email = @landlord_email
 AND l.role = 'landlord'
JOIN properties p
  ON p.landlord_id = l.id
 AND p.title = 'Sunlit Study Room Near Campus'
WHERE s.email = @student_email
  AND s.role = 'student'
  AND NOT EXISTS (
      SELECT 1
      FROM bookings b
      WHERE b.student_id = s.id
        AND b.property_id = p.id
  );

-- Sample wishlist item against the second property
INSERT INTO wishlist (student_id, property_id)
SELECT
    s.id,
    p.id
FROM users s
JOIN users l
  ON l.email = @landlord_email
 AND l.role = 'landlord'
JOIN properties p
  ON p.landlord_id = l.id
 AND p.title = 'Cozy Corner Room with Window View'
WHERE s.email = @student_email
  AND s.role = 'student'
  AND NOT EXISTS (
      SELECT 1
      FROM wishlist w
      WHERE w.student_id = s.id
        AND w.property_id = p.id
  );

-- Sample review for the accepted booking
INSERT INTO reviews (booking_id, student_id, property_id, rating, comment)
SELECT
    b.id,
    s.id,
    p.id,
    5,
    'Bright, clean, and genuinely good for studying.'
FROM users s
JOIN users l
  ON l.email = @landlord_email
 AND l.role = 'landlord'
JOIN properties p
  ON p.landlord_id = l.id
 AND p.title = 'Sunlit Study Room Near Campus'
JOIN bookings b
  ON b.student_id = s.id
 AND b.property_id = p.id
WHERE s.email = @student_email
  AND s.role = 'student'
  AND b.status = 'accepted'
  AND NOT EXISTS (
      SELECT 1
      FROM reviews r
      WHERE r.booking_id = b.id
  );
