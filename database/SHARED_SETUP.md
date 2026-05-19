UniNest shared-data setup

1. Configure one MySQL server that both users can reach.
2. Set the same values in `src/main/resources/uninest.properties`:
   - `UNINEST_DB_HOST`
   - `UNINEST_DB_PORT`
   - `UNINEST_DB_NAME`
   - `UNINEST_DB_USER`
   - `UNINEST_DB_PASSWORD`
3. Deploy one UniNest WAR to one Tomcat server.
4. Open that same server URL from both devices.

If each laptop runs its own Tomcat app and its own `localhost` MySQL database, registrations, property listings, bookings, wishlist items, and roommate requests will stay separate.
