# UniNest – Member 2: Property Management & Booking System
## Your Files (10 files | ~1,205 lines)

| File | Lines | Role |
|------|-------|------|
| controller/PropertyServlet.java | 223 | 10 actions: list/detail/add/edit/delete/approve + image upload |
| controller/BookingServlet.java | 110 | Booking lifecycle: send/view/accept/reject |
| controller/UploadServlet.java | 59 | Serves uploaded images — MUST stay with PropertyServlet |
| dao/PropertyDAO.java | 175 | CRUD + dynamic search SQL + status management |
| dao/BookingDAO.java | 108 | Booking queries with 4-table JOIN |
| model/Property.java | 62 | Property POJO |
| model/Booking.java | 61 | Booking POJO with denormalized review fields |
| webapp/jsp/search.jsp | 113 | Search/browse + card grid |
| webapp/jsp/booking.jsp | 165 | Booking table for student/landlord |
| webapp/jsp/property-detail.jsp | 129 | Full property page + booking form |

## CRITICAL Dependencies
- `PropertyServlet.saveUploadedImage()` calls `UploadServlet.getUploadDirectory()` statically — **UploadServlet must always be in the same package**
- `BookingDAO.alreadyBooked()` is called inside `PropertyServlet` — internal, no conflict
- Booking status values are: `pending`, `accepted`, `rejected` — **do NOT change these strings** (Member 3 and 4 depend on them)

## Your Public Methods (used by other members)
- `PropertyDAO.search()`, `getByLandlord()`, `getAll()`, `findById()`, `countAll()`, `countPending()` — used by `home.jsp` (M1) and `admin-dashboard.jsp` (M5)
- `BookingDAO.getByStudent()`, `getByLandlord()`, `countAll()` — used by `home.jsp` (M1) and `admin-dashboard.jsp` (M5)
- **Do NOT rename these methods**
