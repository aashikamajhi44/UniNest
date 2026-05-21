
# UniNest

UniNest is a Java MVC web application for student housing management. It helps students find verified rental properties, send booking requests, manage roommate connections, save wishlisted rooms, and review completed stays. Landlords can manage listings and bookings, while admins oversee users and property approvals.

## Tech Stack

| Layer | Technology |
| --- | --- |
| Frontend | JSP, JSTL, HTML5, CSS3 |
| Backend | Java 11, Jakarta Servlets |
| Database | MySQL |
| Build Tool | Maven |
| Server | Apache Tomcat |
| Auth & Security | Session-based auth, AuthFilter, BCrypt password hashing |
| File Uploads | Jakarta Servlet multipart upload |

## Project Structure

```text
UNINEST/
|-- database/
|   |-- uninest_schema.sql
|   |-- uninest_seed.sql
|   `-- SHARED_SETUP.md
|-- src/main/
|   |-- java/
|   |   |-- controller/       # Servlets for auth, profile, listings, bookings, reviews
|   |   |-- dao/              # Database access classes
|   |   |-- filter/           # Authentication filter
|   |   |-- model/            # Java model classes
|   |   `-- util/             # DB connection and password utilities
|   |-- resources/
|   |   `-- uninest.properties
|   `-- webapp/
|       |-- css/              # Application styling
|       |-- images/           # UI and property images
|       |-- jsp/              # JSP pages
|       |-- WEB-INF/web.xml   # Servlet and filter mappings
|       `-- index.jsp
`-- pom.xml
```

## Key Features

- Student, landlord, and admin roles
- Student and landlord registration/login
- BCrypt password hashing
- Protected pages using `AuthFilter`
- Profile page for updating account details
- Admin dashboard for user and property oversight
- Property listing management for landlords
- Property approval workflow
- Property search and detail pages for students
- Booking request management
- Roommate request and connection features
- Wishlist support for saved properties
- Review and rating support for accepted bookings
- Shared database configuration through `uninest.properties`

## Main Database Tables

| Table | Description |
| --- | --- |
| `users` | Student, landlord, and admin accounts |
| `properties` | Housing listings created by landlords |
| `bookings` | Booking requests between students and listings |
| `roommate_requests` | Roommate connection requests |
| `wishlist` | Saved properties for students |
| `reviews` | Ratings and comments for accepted bookings |

## Important Routes

| Route | Servlet | Description |
| --- | --- | --- |
| `/LoginServlet` | `LoginServlet` | Login and logout flow |
| `/RegisterServlet` | `RegisterServlet` | User registration |
| `/ProfileServlet` | `ProfileServlet` | Profile view and updates |
| `/PropertyServlet` | `PropertyServlet` | Property listing, search, add, edit, delete |
| `/BookingServlet` | `BookingServlet` | Booking requests and status updates |
| `/RoommateServlet` | `RoommateServlet` | Roommate requests and connections |
| `/WishlistServlet` | `WishlistServlet` | Wishlist actions |
| `/ReviewServlet` | `ReviewServlet` | Review creation and update |
| `/AdminServlet` | `AdminServlet` | Admin dashboard actions |
| `/uploads/*` | `UploadServlet` | Uploaded property images |

## Group Members Contribution

| Member Name | Contribution |
| --- | --- |
| **Aashika Majhi** | - Developed the Authentication & User Management module.<br>- Implemented login, registration, session handling, and profile management functionalities. |
| **Aishwarya Chaudhary** | - Developed the Property & Booking Management module.<br>- Implemented property CRUD operations, booking requests, and booking status management. |
| **Nischal Giri** | - Developed the Admin Panel, Database Integration, and Frontend Design.<br>- Implemented admin dashboard functionalities, approval workflows, and database connectivity. |
| **Nischal Mishra** | - Developed the Wishlist module.<br>- Implemented wishlist add/remove functionality and saved property management. |
| **Puskar Raj Kafle** | - Developed the Roommate & Review module.<br>- Implemented roommate request handling, roommate connection logic, and review/rating functionality. |

## Getting Started

### Prerequisites

- Java 11+
- Maven 3+
- Apache Tomcat 10/11
- MySQL or MariaDB
- XAMPP can be used for local MySQL/MariaDB

### 1. Clone the Repository

```bash
git clone <repository-url>
cd "UNINEST"

```

### 2. Configure the Database

The app reads database settings from `src/main/resources/uninest.properties`.

```properties
UNINEST_DB_HOST=localhost
UNINEST_DB_PORT=3306
UNINEST_DB_NAME=uninest_db
UNINEST_DB_USER=root
UNINEST_DB_PASSWORD=
```

Update these values if your MySQL username, password, port, or database name is different.

### 3. Create or Seed the Database

The application can create required tables during startup through `DBConnection`.

You can also run the SQL files manually:

```bash
mysql -u root -p < database/uninest_schema.sql
mysql -u root -p uninest_db < database/uninest_seed.sql
```

### 4. Build the Project

```bash
mvn clean package
```

This creates:

```text
target/UniNest.war
```

### 5. Run on Tomcat

Deploy `target/UniNest.war` to Tomcat, then open:

```text
http://localhost:8080/UniNest
```

## Default Admin

The application ensures a default admin account exists:

| Role | Email | Password |
| --- | --- | --- |
| Admin | `admin@uninest.com` | `admin123` |

Change this password after first login for real use.

## Environment Notes

- Do not commit machine-specific IDE files or generated build output.
- Do not commit local database passwords.
- If using XAMPP, make sure MySQL/MariaDB is running on the same port configured in `uninest.properties`.
- If Tomcat already uses port `8080`, change the connector port in Tomcat's `conf/server.xml`.

## License

Developed as a student academic project.
