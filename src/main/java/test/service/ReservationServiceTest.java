package test.service;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;
import com.app.model.Reservation;
import com.app.dao.ReservationDAO;
import com.app.dao.RoomDAO;
import com.app.service.ReservationService;
import com.app.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class ReservationServiceTest {

    private static ReservationService reservationService;
    private static ReservationDAO     reservationDAO;
    private static RoomDAO            roomDAO;

    // ─── Use fixed future dates ───────────────────────────────────────────────
    private static final LocalDate CHECK_IN  = LocalDate.now().plusDays(30);
    private static final LocalDate CHECK_OUT = LocalDate.now().plusDays(33); // 3 nights

    // ─── IMPORTANT: Use real IDs that already exist in your DB ───────────────
    private static final int REAL_GUEST_ID    = 1;
    private static final int REAL_ROOM_ID_1   = 1;
    private static final int REAL_ROOM_ID_2   = 2;
    private static final int REAL_STAFF_ID = 5;  

    @BeforeAll
    static void setUpAll() {
        reservationDAO     = new ReservationDAO();
        roomDAO            = new RoomDAO();
        reservationService = new ReservationService();
    }

    // ─── Only clean reservations table ───────────────────────────────────────

    @BeforeEach
    void cleanTable() throws Exception {
        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement()) {
            st.executeUpdate("DELETE FROM reservations");
            st.executeUpdate("ALTER TABLE reservations AUTO_INCREMENT = 1");
        }
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private Reservation buildReservation(int guestId, int roomId,
                                          LocalDate checkIn, LocalDate checkOut,
                                          int adults, int children, String status) {
        Reservation r = new Reservation();
        r.setGuestId(guestId);
        r.setRoomId(roomId);
        r.setCheckInDate(checkIn);
        r.setCheckOutDate(checkOut);
        r.setNumAdults(adults);
        r.setNumChildren(children);
        r.setStatus(status);
        r.setTotalAmount(new BigDecimal("45000.00"));
        r.setSource("Phone");
        r.setBookedBy(REAL_STAFF_ID); 
        return r;
    }

    // Default overload — 2 adults, 0 children, Confirmed, room 1
    private Reservation buildReservation(LocalDate checkIn, LocalDate checkOut) {
        return buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_1, checkIn, checkOut, 2, 0, "Confirmed");
    }

    // ─── addReservation() ─────────────────────────────────────────────────────

    @Test
    @Order(1)
    @DisplayName("TC001: addReservation - Success with valid data")
    void testAddReservationSuccess() throws SQLException {
        // INPUT
        Reservation res = buildReservation(CHECK_IN, CHECK_OUT);

        // ACTUAL
        boolean result = reservationService.addReservation(res);

        // ASSERT
        assertTrue(result, "Should insert successfully");

        List<Reservation> all = reservationDAO.getAllReservations();
        assertEquals(1, all.size(), "One reservation should exist in DB");
        assertEquals(REAL_GUEST_ID,  all.get(0).getGuestId());
        assertEquals(REAL_ROOM_ID_1, all.get(0).getRoomId());
    }

    @Test
    @Order(2)
    @DisplayName("TC002: addReservation - Blocked when dates overlap same room")
    void testAddReservationRoomNotAvailable() throws SQLException {
        // INPUT — insert first reservation
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));

        // Try booking same room with overlapping dates
        Reservation overlap = buildReservation(
            REAL_GUEST_ID, REAL_ROOM_ID_1,
            CHECK_IN.plusDays(1), CHECK_OUT.plusDays(2),
            2, 0, "Confirmed"
        );

        // ASSERT — service throws IllegalArgumentException
        IllegalArgumentException ex = assertThrows(
            IllegalArgumentException.class,
            () -> reservationService.addReservation(overlap)
        );
        assertTrue(ex.getMessage().contains("not available"),
            "Error message should mention room not available");
    }

    @Test
    @Order(3)
    @DisplayName("TC003: addReservation - Blocked when total guests exceed max occupancy")
    void testAddReservationExceedsOccupancy() throws SQLException {
        // Room type max_occupancy = 3 (from your real DB)
        // Trying 4 adults — exceeds limit
        Reservation res = buildReservation(
            REAL_GUEST_ID, REAL_ROOM_ID_1,
            CHECK_IN, CHECK_OUT,
            4, 0, "Confirmed"
        );

        // ASSERT
        IllegalArgumentException ex = assertThrows(
            IllegalArgumentException.class,
            () -> reservationService.addReservation(res)
        );
        assertTrue(ex.getMessage().contains("exceeds max occupancy"),
            "Error message should mention max occupancy");
    }

    @Test
    @Order(4)
    @DisplayName("TC004: addReservation - Success when guests equal max occupancy")
    void testAddReservationExactOccupancy() throws SQLException {
        // Exactly at max occupancy — should be allowed
        Reservation res = buildReservation(
            REAL_GUEST_ID, REAL_ROOM_ID_1,
            CHECK_IN, CHECK_OUT,
            2, 1, "Confirmed" // total = 3 = max
        );

        // ACTUAL
        boolean result = reservationService.addReservation(res);

        // ASSERT
        assertTrue(result, "Should allow booking when guests equal max occupancy");
    }

    @Test
    @Order(5)
    @DisplayName("TC005: addReservation - Same room non-overlapping dates allowed")
    void testAddReservationNonOverlappingDates() throws SQLException {
        // INPUT — first booking
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));

        // Second booking starts exactly when first ends — no overlap
        Reservation second = buildReservation(CHECK_OUT, CHECK_OUT.plusDays(3));
        boolean result = reservationService.addReservation(second);

        // ASSERT
        assertTrue(result, "Should allow booking when dates don't overlap");
        assertEquals(2, reservationDAO.getAllReservations().size());
    }

    @Test
    @Order(6)
    @DisplayName("TC006: addReservation - Different rooms same dates allowed")
    void testAddReservationDifferentRoomsSameDates() throws SQLException {
        // INPUT — book room 1
        reservationService.addReservation(
            buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_1, CHECK_IN, CHECK_OUT, 2, 0, "Confirmed")
        );

        // Book room 2 same dates — should succeed
        boolean result = reservationService.addReservation(
            buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_2, CHECK_IN, CHECK_OUT, 2, 0, "Confirmed")
        );

        // ASSERT
        assertTrue(result, "Different rooms can be booked for same dates");
        assertEquals(2, reservationDAO.getAllReservations().size());
    }

    // ─── getReservationById() ─────────────────────────────────────────────────

    @Test
    @Order(7)
    @DisplayName("TC007: getReservationById - Returns correct record")
    void testGetReservationById() throws SQLException {
        // INPUT
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));
        int id = reservationDAO.getAllReservations().get(0).getId();

        // ACTUAL
        Reservation result = reservationService.getReservationById(id);

        // ASSERT
        assertNotNull(result);
        assertEquals(REAL_GUEST_ID,  result.getGuestId());
        assertEquals(REAL_ROOM_ID_1, result.getRoomId());
        assertEquals(CHECK_IN,       result.getCheckInDate());
        assertEquals(CHECK_OUT,      result.getCheckOutDate());
    }

    @Test
    @Order(8)
    @DisplayName("TC008: getReservationById - Returns null for non-existent ID")
    void testGetReservationByIdNotFound() throws SQLException {
        // ACTUAL
        Reservation result = reservationService.getReservationById(999);

        // ASSERT
        assertNull(result, "Should return null for non-existent ID");
    }

    // ─── getReservationByNumber() ─────────────────────────────────────────────

    @Test
    @Order(9)
    @DisplayName("TC009: getReservationByNumber - Returns correct record")
    void testGetReservationByNumber() throws SQLException {
        // INPUT
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));
        Reservation inserted = reservationDAO.getAllReservations().get(0);

        // ACTUAL
        Reservation result = reservationService.getReservationByNumber(
            inserted.getReservationNumber()
        );

        // ASSERT
        assertNotNull(result);
        assertEquals(inserted.getReservationNumber(), result.getReservationNumber());
    }

    @Test
    @Order(10)
    @DisplayName("TC010: getReservationByNumber - Returns null for non-existent number")
    void testGetReservationByNumberNotFound() throws SQLException {
        // ACTUAL
        Reservation result = reservationService.getReservationByNumber("RES-0000-XXXX");

        // ASSERT
        assertNull(result, "Should return null for non-existent reservation number");
    }

    // ─── getAllReservations() ─────────────────────────────────────────────────

    @Test
    @Order(11)
    @DisplayName("TC011: getAllReservations - Returns all reservations")
    void testGetAllReservations() throws SQLException {
        // INPUT — 2 reservations on different rooms
        reservationService.addReservation(
            buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_1, CHECK_IN, CHECK_OUT, 2, 0, "Confirmed")
        );
        reservationService.addReservation(
            buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_2, CHECK_IN, CHECK_OUT, 1, 0, "Confirmed")
        );

        // ACTUAL
        List<Reservation> result = reservationService.getAllReservations();

        // ASSERT
        assertEquals(2, result.size(), "Should return all 2 reservations");
    }

    @Test
    @Order(12)
    @DisplayName("TC012: getAllReservations - Returns empty when table is empty")
    void testGetAllReservationsEmpty() throws SQLException {
        // ACTUAL — table already cleaned in @BeforeEach
        List<Reservation> result = reservationService.getAllReservations();

        // ASSERT
        assertTrue(result.isEmpty(), "Should return empty list");
    }

    // ─── getReservationsByStatus() ────────────────────────────────────────────

    @Test
    @Order(13)
    @DisplayName("TC013: getReservationsByStatus - Returns only matching status")
    void testGetReservationsByStatus() throws SQLException {
        // INPUT — one Confirmed, one Pending on different rooms
        reservationService.addReservation(
            buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_1, CHECK_IN, CHECK_OUT, 2, 0, "Confirmed")
        );
        reservationService.addReservation(
            buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_2, CHECK_IN, CHECK_OUT, 1, 0, "Pending")
        );

        // ACTUAL
        List<Reservation> confirmed = reservationService.getReservationsByStatus("Confirmed");
        List<Reservation> pending   = reservationService.getReservationsByStatus("Pending");

        // ASSERT
        assertEquals(1, confirmed.size(), "Should return 1 Confirmed");
        assertEquals(1, pending.size(),   "Should return 1 Pending");
    }

    @Test
    @Order(14)
    @DisplayName("TC014: getReservationsByStatus - Returns empty for unused status")
    void testGetReservationsByStatusEmpty() throws SQLException {
        // INPUT
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));

        // ACTUAL
        List<Reservation> result = reservationService.getReservationsByStatus("Cancelled");

        // ASSERT
        assertTrue(result.isEmpty(), "Should return empty for status with no reservations");
    }

    // ─── searchReservations() ─────────────────────────────────────────────────

    @Test
    @Order(15)
    @DisplayName("TC015: searchReservations - Null keyword returns all")
    void testSearchReservationsNullKeyword() throws SQLException {
        // INPUT
        reservationService.addReservation(
            buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_1, CHECK_IN, CHECK_OUT, 2, 0, "Confirmed")
        );
        reservationService.addReservation(
            buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_2, CHECK_IN, CHECK_OUT, 1, 0, "Confirmed")
        );

        // ACTUAL
        List<Reservation> result = reservationService.searchReservations(null);

        // ASSERT
        assertEquals(2, result.size(), "Null keyword should return all reservations");
    }

    @Test
    @Order(16)
    @DisplayName("TC016: searchReservations - Empty keyword returns all")
    void testSearchReservationsEmptyKeyword() throws SQLException {
        // INPUT
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));

        // ACTUAL
        List<Reservation> result = reservationService.searchReservations("   ");

        // ASSERT
        assertEquals(1, result.size(), "Empty keyword should return all reservations");
    }

    // ─── updateStatus() ───────────────────────────────────────────────────────

    @Test
    @Order(17)
    @DisplayName("TC017: updateStatus - Successfully changes status")
    void testUpdateStatus() throws SQLException {
        // INPUT
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));
        int id = reservationDAO.getAllReservations().get(0).getId();

        // ACTUAL
        boolean result = reservationService.updateStatus(id, "Cancelled");

        // ASSERT
        assertTrue(result, "Should update status successfully");
        assertEquals("Cancelled", reservationDAO.getReservationById(id).getStatus());
    }

    // ─── checkIn() ────────────────────────────────────────────────────────────

    @Test
    @Order(18)
    @DisplayName("TC018: checkIn - Updates reservation to CheckedIn and room to Occupied")
    void testCheckIn() throws SQLException {
        // INPUT
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));
        int id = reservationDAO.getAllReservations().get(0).getId();

        // ACTUAL
        boolean result = reservationService.checkIn(id);

        // ASSERT
        assertTrue(result, "CheckIn should succeed");

        // Reservation → CheckedIn
        assertEquals("CheckedIn",
            reservationDAO.getReservationById(id).getStatus(),
            "Reservation status should be CheckedIn"
        );

        // Room → Occupied
        assertEquals("Occupied",
            roomDAO.getRoomById(REAL_ROOM_ID_1).getStatus(),
            "Room should be Occupied after check-in"
        );
    }

    // ─── checkOut() ───────────────────────────────────────────────────────────

    @Test
    @Order(19)
    @DisplayName("TC019: checkOut - Updates reservation to CheckedOut and room to Available")
    void testCheckOut() throws SQLException {
        // INPUT — check in first, then check out
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));
        int id = reservationDAO.getAllReservations().get(0).getId();
        reservationService.checkIn(id);

        // ACTUAL
        boolean result = reservationService.checkOut(id);

        // ASSERT
        assertTrue(result, "CheckOut should succeed");

        // Reservation → CheckedOut
        assertEquals("CheckedOut",
            reservationDAO.getReservationById(id).getStatus(),
            "Reservation status should be CheckedOut"
        );

        // Room → Available
        assertEquals("Available",
            roomDAO.getRoomById(REAL_ROOM_ID_1).getStatus(),
            "Room should be Available after check-out"
        );
    }

    // ─── cancelReservation() ──────────────────────────────────────────────────

    @Test
    @Order(20)
    @DisplayName("TC020: cancelReservation - Successfully cancels reservation")
    void testCancelReservation() throws SQLException {
        // INPUT
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));
        int id = reservationDAO.getAllReservations().get(0).getId();

        // ACTUAL
        boolean result = reservationService.cancelReservation(id);

        // ASSERT
        assertTrue(result, "Should cancel successfully");
        assertEquals("Cancelled",
            reservationDAO.getReservationById(id).getStatus()
        );
    }

    // ─── confirmReservation() ─────────────────────────────────────────────────

    @Test
    @Order(21)
    @DisplayName("TC021: confirmReservation - Updates to Confirmed and room to Reserved")
    void testConfirmReservation() throws SQLException {
        // INPUT — start as Pending
        Reservation res = buildReservation(
            REAL_GUEST_ID, REAL_ROOM_ID_1,
            CHECK_IN, CHECK_OUT,
            2, 0, "Pending"
        );
        reservationService.addReservation(res);
        int id = reservationDAO.getAllReservations().get(0).getId();

        // ACTUAL
        boolean result = reservationService.confirmReservation(id);

        // ASSERT
        assertTrue(result, "Should confirm successfully");

        assertEquals("Confirmed",
            reservationDAO.getReservationById(id).getStatus(),
            "Reservation should be Confirmed"
        );
        assertEquals("Reserved",
            roomDAO.getRoomById(REAL_ROOM_ID_1).getStatus(),
            "Room should be Reserved after confirmation"
        );
    }

    // ─── deleteReservation() ──────────────────────────────────────────────────

    @Test
    @Order(22)
    @DisplayName("TC022: deleteReservation - Successfully deletes Cancelled reservation")
    void testDeleteCancelledReservation() throws SQLException {
        // INPUT
        Reservation res = buildReservation(
            REAL_GUEST_ID, REAL_ROOM_ID_1,
            CHECK_IN, CHECK_OUT,
            2, 0, "Cancelled"
        );
        reservationService.addReservation(res);
        int id = reservationDAO.getAllReservations().get(0).getId();

        // ACTUAL
        boolean result = reservationService.deleteReservation(id);

        // ASSERT
        assertTrue(result, "Should delete Cancelled reservation");
        assertNull(reservationDAO.getReservationById(id),
            "Should not exist after delete"
        );
    }

    @Test
    @Order(23)
    @DisplayName("TC023: deleteReservation - Successfully deletes Pending reservation")
    void testDeletePendingReservation() throws SQLException {
        // INPUT
        Reservation res = buildReservation(
            REAL_GUEST_ID, REAL_ROOM_ID_1,
            CHECK_IN, CHECK_OUT,
            2, 0, "Pending"
        );
        reservationService.addReservation(res);
        int id = reservationDAO.getAllReservations().get(0).getId();

        // ACTUAL
        boolean result = reservationService.deleteReservation(id);

        // ASSERT
        assertTrue(result, "Should delete Pending reservation");
        assertNull(reservationDAO.getReservationById(id),
            "Should not exist after delete"
        );
    }

    @Test
    @Order(24)
    @DisplayName("TC024: deleteReservation - Blocked for Confirmed reservation")
    void testDeleteConfirmedBlocked() throws SQLException {
        // INPUT
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));
        int id = reservationDAO.getAllReservations().get(0).getId();

        // ACTUAL
        boolean result = reservationService.deleteReservation(id);

        // ASSERT
        assertFalse(result, "Should NOT delete a Confirmed reservation");
        assertNotNull(reservationDAO.getReservationById(id),
            "Reservation should still exist"
        );
    }

    @Test
    @Order(25)
    @DisplayName("TC025: deleteReservation - Blocked for CheckedIn reservation")
    void testDeleteCheckedInBlocked() throws SQLException {
        // INPUT — check in first
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));
        int id = reservationDAO.getAllReservations().get(0).getId();
        reservationService.checkIn(id);

        // ACTUAL
        boolean result = reservationService.deleteReservation(id);

        // ASSERT
        assertFalse(result, "Should NOT delete a CheckedIn reservation");
        assertNotNull(reservationDAO.getReservationById(id),
            "Reservation should still exist"
        );
    }

    // ─── isRoomAvailable() ────────────────────────────────────────────────────

    @Test
    @Order(26)
    @DisplayName("TC026: isRoomAvailable - True when no reservations exist")
    void testIsRoomAvailableTrue() throws SQLException {
        // ACTUAL — table is empty
        boolean result = reservationService.isRoomAvailable(REAL_ROOM_ID_1, CHECK_IN, CHECK_OUT);

        // ASSERT
        assertTrue(result, "Room should be available when no reservations exist");
    }

    @Test
    @Order(27)
    @DisplayName("TC027: isRoomAvailable - False when dates overlap")
    void testIsRoomAvailableFalse() throws SQLException {
        // INPUT — book room 1
        reservationService.addReservation(buildReservation(CHECK_IN, CHECK_OUT));

        // ACTUAL — overlapping dates
        boolean result = reservationService.isRoomAvailable(
            REAL_ROOM_ID_1,
            CHECK_IN.plusDays(1),
            CHECK_OUT.plusDays(1)
        );

        // ASSERT
        assertFalse(result, "Room should not be available for overlapping dates");
    }

    // ─── calculateReservationTotal() ─────────────────────────────────────────

    @Test
    @Order(28)
    @DisplayName("TC028: calculateReservationTotal - Uses base price when no seasonal rate")
    void testCalculateTotalBasePrice() throws SQLException {
        // Room type base price from your real DB × 3 nights
        // Adjust expected value to match your real room type base price
        BigDecimal result = reservationService.calculateReservationTotal(
            REAL_ROOM_ID_1, CHECK_IN, CHECK_OUT
        );

        // ASSERT — must be > 0 and have 2 decimal places
        assertTrue(result.compareTo(BigDecimal.ZERO) > 0,
            "Total should be greater than zero");
        assertEquals(2, result.scale(),
            "Total should be rounded to 2 decimal places"
        );
    }

    @Test
    @Order(29)
    @DisplayName("TC029: calculateReservationTotal - Returns zero for invalid room")
    void testCalculateTotalInvalidRoom() throws SQLException {
        // ACTUAL
        BigDecimal result = reservationService.calculateReservationTotal(
            999, CHECK_IN, CHECK_OUT
        );

        // ASSERT
        assertEquals(0, BigDecimal.ZERO.compareTo(result),
            "Should return zero for non-existent room"
        );
    }

    // ─── getReservationCountByStatus() ───────────────────────────────────────

    @Test
    @Order(30)
    @DisplayName("TC030: getReservationCountByStatus - Returns correct count")
    void testGetReservationCountByStatus() throws SQLException {
        // INPUT — 2 Confirmed on different rooms
        reservationService.addReservation(
            buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_1, CHECK_IN, CHECK_OUT, 2, 0, "Confirmed")
        );
        reservationService.addReservation(
            buildReservation(REAL_GUEST_ID, REAL_ROOM_ID_2, CHECK_IN, CHECK_OUT, 1, 0, "Confirmed")
        );

        // ACTUAL
        int count = reservationService.getReservationCountByStatus("Confirmed");

        // ASSERT
        assertEquals(2, count, "Should count 2 Confirmed reservations");
    }

    @Test
    @Order(31)
    @DisplayName("TC031: getReservationCountByStatus - Returns zero for empty status")
    void testGetReservationCountByStatusZero() throws SQLException {
        // ACTUAL — empty table
        int count = reservationService.getReservationCountByStatus("CheckedIn");

        // ASSERT
        assertEquals(0, count, "Should return 0 when no reservations with that status");
    }
}