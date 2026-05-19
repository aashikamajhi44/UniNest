# UniNest SAMS – Member 2: Property Management & Booking System
## 🔴 UPDATE STATUS: 4 files updated — includes real logic changes

| File | Lines | Updated? | What Changed |
|------|-------|----------|--------------|
| controller/PropertyServlet.java | 264 | 🔴 LOGIC UPDATED | +41 lines: WishlistDAO integrated — detail page now pre-loads wishlisted IDs for students |
| controller/BookingServlet.java | 145 | 🟡 UPDATED | +35 lines: Javadoc + minor null-safety improvements |
| controller/UploadServlet.java | 59 | ✅ Same | No change |
| dao/PropertyDAO.java | 175 | ✅ Same | No logic change |
| dao/BookingDAO.java | 119 | 🟡 UPDATED | +11 lines: Javadoc added |
| model/Property.java | 62 | ✅ Same | No change |
| model/Booking.java | 61 | ✅ Same | No change |
| webapp/jsp/search.jsp | 116 | 🟡 UPDATED | +3 lines: minor UI fix |
| webapp/jsp/booking.jsp | 166 | ✅ Same | No logic change |
| webapp/jsp/property-detail.jsp | 144 | 🔴 LOGIC UPDATED | +15 lines: wishlist heart icon now displays correctly on detail page |

**Total: ~1,311 lines across 10 files**

## What Was Updated in This Version

### PropertyServlet.java (+41 lines — REAL LOGIC CHANGE ⚠️)
- Added `private final WishlistDAO wishlistDAO = new WishlistDAO();` as a class field
- In the `detail` action: if user is a student, now calls `wishlistDAO.getPropertyIds(user.getId())` and sets result as `"wishlistedPropertyIds"` request attribute
- This means `property-detail.jsp` can now show the filled/empty heart icon correctly for logged-in students
- **You now have a dependency on WishlistDAO (Member 4's DAO)** — coordinate imports

### property-detail.jsp (+15 lines — REAL LOGIC CHANGE ⚠️)
- Heart icon wishlist toggle button now reads `wishlistedPropertyIds` attribute set by PropertyServlet
- Displays filled heart (❤️) if already wishlisted, empty heart (🤍) if not
- Links correctly to `WishlistServlet?action=toggle`

### BookingDAO.java (+11 lines)
- Javadoc added to all methods — no SQL or logic change

### search.jsp (+3 lines)
- Minor UI text fix — no functional change

## CRITICAL: Cross-Member Dependency Added in This Version
`PropertyServlet` now imports and calls `dao.WishlistDAO` (Member 4's class).
- **Do not rename `WishlistDAO` or its `getPropertyIds()` method**
- Booking status values `pending`, `accepted`, `rejected` are **unchanged** — Members 3 and 4 still depend on these

## Public Methods (used by other members — do NOT rename)
- `PropertyDAO`: `search()`, `getByLandlord()`, `getAll()`, `findById()`, `countAll()`, `countPending()`
- `BookingDAO`: `getByStudent()`, `getByLandlord()`, `countAll()`
