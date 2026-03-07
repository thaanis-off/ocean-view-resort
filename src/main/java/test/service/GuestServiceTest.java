package test.service;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;
import com.app.model.Guest;
import com.app.dao.GuestDAO;
import com.app.service.GuestService;
import com.app.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.List;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class GuestServiceTest {

    private static GuestService guestService;
    private static GuestDAO     guestDAO;

    // ─── Setup before ALL tests ───────────────────────────────────────────────

    @BeforeAll
    static void setUpAll() {
        guestDAO     = new GuestDAO();
        guestService = new GuestService();
    }

    // ─── Clean table before EACH test ─────────────────────────────────────────

    @BeforeEach
    void cleanTable() throws Exception {
        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement()) {
            st.executeUpdate("DELETE FROM guests");
            st.executeUpdate("ALTER TABLE guests AUTO_INCREMENT = 1");
        }
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private Guest buildGuest(String firstName, String lastName, String email,
                              String phone, String nicPassport) {
        Guest guest = new Guest();
        guest.setFirstName(firstName);
        guest.setLastName(lastName);
        guest.setEmail(email);
        guest.setPhone(phone);
        guest.setNicPassport(nicPassport);
        guest.setNationality("Sri Lankan");
        guest.setAddress("123 Test Street, Colombo");
        return guest;
    }

    // Overload — minimal guest without NIC
    private Guest buildGuest(String firstName, String lastName, String email, String phone) {
        return buildGuest(firstName, lastName, email, phone, null);
    }

    // ─── addGuest() ───────────────────────────────────────────────────────────

    @Test
    @Order(1)
    @DisplayName("TC001: addGuest - Success with unique email and NIC")
    void testAddGuestSuccess() throws SQLException {
        // INPUT
        Guest guest = buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771234567", "200012345678");

        // ACTUAL
        boolean result = guestService.addGuest(guest);

        // ASSERT
        assertTrue(result, "Should insert successfully");

        // Verify it actually exists in DB
        Guest saved = guestDAO.getGuestByEmail("thaanis@email.com");
        assertNotNull(saved, "Should be found in DB after insert");
        assertEquals("Thaanis", saved.getFirstName());
        assertEquals("Mohamed", saved.getLastName());
    }

    @Test
    @Order(2)
    @DisplayName("TC002: addGuest - Blocked on duplicate email")
    void testAddGuestDuplicateEmail() throws SQLException {
        // INPUT — insert first guest
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771234567", "200012345678"));

        // Try inserting different person with same email
        boolean result = guestService.addGuest(buildGuest("Ali", "Hassan", "thaanis@email.com", "0779999999", "199987654321"));

        // ASSERT
        assertFalse(result, "Should block duplicate email");

        // Verify only one guest exists
        assertEquals(1, guestDAO.getAllGuests().size(), "Only one guest should exist");
    }

    @Test
    @Order(3)
    @DisplayName("TC003: addGuest - Blocked on duplicate NIC/Passport")
    void testAddGuestDuplicateNic() throws SQLException {
        // INPUT — insert first guest
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771234567", "200012345678"));

        // Try inserting different email but same NIC
        boolean result = guestService.addGuest(buildGuest("Ali", "Hassan", "ali@email.com", "0779999999", "200012345678"));

        // ASSERT
        assertFalse(result, "Should block duplicate NIC/Passport");
    }

    @Test
    @Order(4)
    @DisplayName("TC004: addGuest - Success when NIC is null")
    void testAddGuestNullNic() throws SQLException {
        // INPUT — NIC not provided
        Guest guest = buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771234567", null);

        // ACTUAL
        boolean result = guestService.addGuest(guest);

        // ASSERT
        assertTrue(result, "Should insert successfully when NIC is null");
    }

    @Test
    @Order(5)
    @DisplayName("TC005: addGuest - Success when NIC is empty string")
    void testAddGuestEmptyNic() throws SQLException {
        // INPUT — NIC is empty
        Guest guest = buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771234567", "");

        // ACTUAL
        boolean result = guestService.addGuest(guest);

        // ASSERT
        assertTrue(result, "Should insert successfully when NIC is empty");
    }

    // ─── getGuestById() ───────────────────────────────────────────────────────

    @Test
    @Order(6)
    @DisplayName("TC006: getGuestById - Returns correct record")
    void testGetGuestById() throws SQLException {
        // INPUT
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771234567", "200012345678"));
        Guest inserted = guestDAO.getGuestByEmail("thaanis@email.com");

        // ACTUAL
        Guest result = guestService.getGuestById(inserted.getId());

        // ASSERT
        assertNotNull(result);
        assertEquals("Thaanis", result.getFirstName());
        assertEquals("thaanis@email.com", result.getEmail());
    }

    @Test
    @Order(7)
    @DisplayName("TC007: getGuestById - Returns null for non-existent ID")
    void testGetGuestByIdNotFound() throws SQLException {
        // ACTUAL
        Guest result = guestService.getGuestById(999);

        // ASSERT
        assertNull(result, "Should return null for ID that doesn't exist");
    }

    // ─── getGuestByEmail() ────────────────────────────────────────────────────

    @Test
    @Order(8)
    @DisplayName("TC008: getGuestByEmail - Returns correct guest")
    void testGetGuestByEmail() throws SQLException {
        // INPUT
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771234567"));

        // ACTUAL
        Guest result = guestService.getGuestByEmail("thaanis@email.com");

        // ASSERT
        assertNotNull(result);
        assertEquals("thaanis@email.com", result.getEmail());
    }

    @Test
    @Order(9)
    @DisplayName("TC009: getGuestByEmail - Returns null when not found")
    void testGetGuestByEmailNotFound() throws SQLException {
        // ACTUAL
        Guest result = guestService.getGuestByEmail("notexist@email.com");

        // ASSERT
        assertNull(result, "Should return null for non-existent email");
    }

    // ─── getAllGuests() ───────────────────────────────────────────────────────

    @Test
    @Order(10)
    @DisplayName("TC010: getAllGuests - Returns all inserted guests")
    void testGetAllGuests() throws SQLException {
        // INPUT — insert 3 guests
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111", "200012345678"));
        guestService.addGuest(buildGuest("Ali",     "Hassan",  "ali@email.com",     "0772222222", "199987654321"));
        guestService.addGuest(buildGuest("Sara",    "Perera",  "sara@email.com",    "0773333333", "199811112222"));

        // ACTUAL
        List<Guest> result = guestService.getAllGuests();

        // ASSERT
        assertEquals(3, result.size(), "Should return all 3 guests");
    }

    @Test
    @Order(11)
    @DisplayName("TC011: getAllGuests - Returns empty when table is empty")
    void testGetAllGuestsEmpty() throws SQLException {
        // ACTUAL — table already cleaned in @BeforeEach
        List<Guest> result = guestService.getAllGuests();

        // ASSERT
        assertTrue(result.isEmpty(), "Should return empty list");
    }

    // ─── searchGuests() ───────────────────────────────────────────────────────

    @Test
    @Order(12)
    @DisplayName("TC012: searchGuests - Finds matching guest by name")
    void testSearchGuestsFound() throws SQLException {
        // INPUT
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111", "200012345678"));
        guestService.addGuest(buildGuest("Ali",     "Hassan",  "ali@email.com",     "0772222222", "199987654321"));

        // ACTUAL
        List<Guest> result = guestService.searchGuests("Thaanis");

        // ASSERT
        assertEquals(1, result.size());
        assertEquals("Thaanis", result.get(0).getFirstName());
    }

    @Test
    @Order(13)
    @DisplayName("TC013: searchGuests - Null keyword returns all guests")
    void testSearchGuestsNullKeyword() throws SQLException {
        // INPUT
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111", "200012345678"));
        guestService.addGuest(buildGuest("Ali",     "Hassan",  "ali@email.com",     "0772222222", "199987654321"));

        // ACTUAL
        List<Guest> result = guestService.searchGuests(null);

        // ASSERT
        assertEquals(2, result.size(), "Null keyword should return all guests");
    }

    @Test
    @Order(14)
    @DisplayName("TC014: searchGuests - Empty keyword returns all guests")
    void testSearchGuestsEmptyKeyword() throws SQLException {
        // INPUT
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111"));

        // ACTUAL
        List<Guest> result = guestService.searchGuests("   ");

        // ASSERT
        assertEquals(1, result.size(), "Empty keyword should return all guests");
    }

    @Test
    @Order(15)
    @DisplayName("TC015: searchGuests - No match returns empty list")
    void testSearchGuestsNoMatch() throws SQLException {
        // INPUT
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111"));

        // ACTUAL
        List<Guest> result = guestService.searchGuests("Ruwan");

        // ASSERT
        assertTrue(result.isEmpty(), "Should return empty when no match found");
    }

    // ─── updateGuest() ────────────────────────────────────────────────────────

    @Test
    @Order(16)
    @DisplayName("TC016: updateGuest - Successfully updates record")
    void testUpdateGuestSuccess() throws SQLException {
        // INPUT — insert then update
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111", "200012345678"));
        Guest existing = guestDAO.getGuestByEmail("thaanis@email.com");

        existing.setFirstName("Thaanis Updated");
        existing.setPhone("0779999999");

        // ACTUAL
        boolean result = guestService.updateGuest(existing);

        // ASSERT
        assertTrue(result, "Should update successfully");

        // Verify change persisted in DB
        Guest updated = guestDAO.getGuestById(existing.getId());
        assertEquals("Thaanis Updated", updated.getFirstName());
        assertEquals("0779999999",      updated.getPhone());
    }

    @Test
    @Order(17)
    @DisplayName("TC017: updateGuest - Blocked when NIC taken by another guest")
    void testUpdateGuestDuplicateNic() throws SQLException {
        // INPUT — insert two guests
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111", "200012345678"));
        guestService.addGuest(buildGuest("Ali",     "Hassan",  "ali@email.com",     "0772222222", "199987654321"));

        // Try updating Thaanis with Ali's NIC
        Guest thaanis = guestDAO.getGuestByEmail("thaanis@email.com");
        thaanis.setNicPassport("199987654321");

        // ACTUAL
        boolean result = guestService.updateGuest(thaanis);

        // ASSERT
        assertFalse(result, "Should block update when NIC is taken by another guest");
    }

    @Test
    @Order(18)
    @DisplayName("TC018: updateGuest - Success updating own record keeping same NIC")
    void testUpdateGuestSameNic() throws SQLException {
        // INPUT — insert guest then update non-NIC field
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111", "200012345678"));
        Guest existing = guestDAO.getGuestByEmail("thaanis@email.com");

        // Change only phone, keep same NIC
        existing.setPhone("0779999999");

        // ACTUAL
        boolean result = guestService.updateGuest(existing);

        // ASSERT
        assertTrue(result, "Should allow update when keeping own NIC");
    }

    // ─── deleteGuest() ────────────────────────────────────────────────────────

    @Test
    @Order(19)
    @DisplayName("TC019: deleteGuest - Successfully soft deletes guest")
    void testDeleteGuestSuccess() throws SQLException {
        // INPUT
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111"));
        Guest guest = guestDAO.getGuestByEmail("thaanis@email.com");

        // ACTUAL
        boolean result = guestService.deleteGuest(guest.getId());

        // ASSERT
        assertTrue(result, "Should soft delete successfully");

        // Verify inactive in DB (soft delete — row still exists but is_active = 0)
        Guest deleted = guestDAO.getGuestById(guest.getId());
        assertNotNull(deleted, "Row should still exist after soft delete");
        assertFalse(deleted.isActive(), "Guest should be marked inactive after delete");
    }

    // ─── toggleBlacklist() ────────────────────────────────────────────────────

    @Test
    @Order(20)
    @DisplayName("TC020: toggleBlacklist - Blacklists a guest")
    void testToggleBlacklistTrue() throws SQLException {
        // INPUT
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111"));
        Guest guest = guestDAO.getGuestByEmail("thaanis@email.com");

        // ACTUAL
        boolean result = guestService.toggleBlacklist(guest.getId(), true);

        // ASSERT
        assertTrue(result, "Should blacklist successfully");

        // Verify in DB
        Guest updated = guestDAO.getGuestById(guest.getId());
        assertTrue(updated.isBlacklisted(), "Guest should be blacklisted");
    }

    @Test
    @Order(21)
    @DisplayName("TC021: toggleBlacklist - Removes blacklist from guest")
    void testToggleBlacklistFalse() throws SQLException {
        // INPUT — add and blacklist first
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111"));
        Guest guest = guestDAO.getGuestByEmail("thaanis@email.com");
        guestService.toggleBlacklist(guest.getId(), true);

        // ACTUAL — now remove blacklist
        boolean result = guestService.toggleBlacklist(guest.getId(), false);

        // ASSERT
        assertTrue(result, "Should remove blacklist successfully");

        Guest updated = guestDAO.getGuestById(guest.getId());
        assertFalse(updated.isBlacklisted(), "Guest should no longer be blacklisted");
    }

    // ─── emailExists() ────────────────────────────────────────────────────────

    @Test
    @Order(22)
    @DisplayName("TC022: emailExists - Returns true when exists")
    void testEmailExistsTrue() throws SQLException {
        // INPUT
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111"));

        // ASSERT
        assertTrue(guestService.emailExists("thaanis@email.com"));
    }

    @Test
    @Order(23)
    @DisplayName("TC023: emailExists - Returns false when not exists")
    void testEmailExistsFalse() throws SQLException {
        // ASSERT
        assertFalse(guestService.emailExists("nobody@email.com"),
            "Should return false for non-existent email");
    }

    // ─── nicPassportExists() ──────────────────────────────────────────────────

    @Test
    @Order(24)
    @DisplayName("TC024: nicPassportExists - Returns true when exists")
    void testNicPassportExistsTrue() throws SQLException {
        // INPUT
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111", "200012345678"));

        // ASSERT
        assertTrue(guestService.nicPassportExists("200012345678"));
    }

    @Test
    @Order(25)
    @DisplayName("TC025: nicPassportExists - Returns false when not exists")
    void testNicPassportExistsFalse() throws SQLException {
        // ASSERT
        assertFalse(guestService.nicPassportExists("000000000000"),
            "Should return false for non-existent NIC");
    }

    // ─── getGuestByCode() ─────────────────────────────────────────────────────

    @Test
    @Order(26)
    @DisplayName("TC026: getGuestByCode - Returns null for non-existent code")
    void testGetGuestByCodeNotFound() throws SQLException {
        // ACTUAL
        Guest result = guestService.getGuestByCode("GST-9999");

        // ASSERT
        assertNull(result, "Should return null for non-existent guest code");
    }

    @Test
    @Order(27)
    @DisplayName("TC027: getGuestByCode - Returns correct guest after insert")
    void testGetGuestByCode() throws SQLException {
        // INPUT — insert and retrieve the generated code
        guestService.addGuest(buildGuest("Thaanis", "Mohamed", "thaanis@email.com", "0771111111"));
        Guest inserted = guestDAO.getGuestByEmail("thaanis@email.com");

        // ACTUAL — use the code that was auto-generated
        Guest result = guestService.getGuestByCode(inserted.getGuestCode());

        // ASSERT
        assertNotNull(result, "Should find guest by generated code");
        assertEquals("Thaanis", result.getFirstName());
        assertEquals(inserted.getGuestCode(), result.getGuestCode());
    }
}