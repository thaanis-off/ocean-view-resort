package test.model;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;

import com.app.model.Guest;
import java.time.LocalDate;
import java.time.LocalDateTime;

class GuestModelTest {
    
    private Guest guest;
    
    @BeforeEach
    void setUp() {
        guest = new Guest();
    }

    // ─── CONSTRUCTOR & DEFAULTS ───────────────────────────────────────────────
    
    @Test
    @DisplayName("TC001: Test Parameterized Constructor Defaults")
    void testConstructor() {
        // INPUT
        String fName = "Alice";
        String lName = "Smith";
        String email = "alice@test.com";
        String phone = "555-0123";
        String addr  = "123 Main St";

        // ACTUAL
        Guest parameterizedGuest = new Guest(fName, lName, email, phone, addr);

        // ASSERT
        assertAll("Verify constructor sets fields and defaults",
            () -> assertEquals(fName, parameterizedGuest.getFirstName()),
            () -> assertEquals(lName, parameterizedGuest.getLastName()),
            () -> assertEquals(email, parameterizedGuest.getEmail()),
            () -> assertEquals(phone, parameterizedGuest.getPhone()),
            () -> assertEquals(addr, parameterizedGuest.getAddress()),
            () -> assertTrue(parameterizedGuest.isActive(), "New guests should be active"),
            () -> assertFalse(parameterizedGuest.isVip(), "New guests should not be VIP"),
            () -> assertFalse(parameterizedGuest.isBlacklisted(), "New guests should not be blacklisted"),
            () -> assertEquals("Regular", parameterizedGuest.getGuestType(), "Default type should be Regular"),
            () -> assertEquals(0, parameterizedGuest.getTotalStays(), "Default stays should be 0")
        );
        System.out.println("TC001: Constructor Test - Passed");
    }

    // ─── EXHAUSTIVE SETTERS & GETTERS ─────────────────────────────────────────

    @Test
    @DisplayName("TC002: Test ALL Setters and Getters")
    void testAllSettersAndGetters() {
        // INPUT - Arrange all possible fields
        int id = 101;
        String code = "GST-101";
        String fName = "John";
        String lName = "Doe";
        String email = "john.doe@example.com";
        String phone = "+94771234567";
        String nic = "951234567V";
        String nationality = "Sri Lankan";
        String address = "Colombo 03";
        String gender = "Male";
        LocalDate dob = LocalDate.of(1995, 5, 20);
        String type = "Corporate";
        int stays = 8;
        LocalDateTime createdAt = LocalDateTime.now();
        boolean active = false; // Testing non-default state
        boolean vip = true;
        boolean blacklisted = true;

        // ACT - Apply all setters
        guest.setId(id);
        guest.setGuestCode(code);
        guest.setFirstName(fName);
        guest.setLastName(lName);
        guest.setEmail(email);
        guest.setPhone(phone);
        guest.setNicPassport(nic);
        guest.setNationality(nationality);
        guest.setAddress(address);
        guest.setGender(gender);
        guest.setDateOfBirth(dob);
        guest.setGuestType(type);
        guest.setTotalStays(stays);
        guest.setCreatedAt(createdAt);
        guest.setActive(active);
        guest.setVip(vip);
        guest.setBlacklisted(blacklisted);

        // ASSERT - Verify all getters
        assertAll("Verify all field setters and getters",
            () -> assertEquals(id, guest.getId()),
            () -> assertEquals(code, guest.getGuestCode()),
            () -> assertEquals(fName, guest.getFirstName()),
            () -> assertEquals(lName, guest.getLastName()),
            () -> assertEquals(email, guest.getEmail()),
            () -> assertEquals(phone, guest.getPhone()),
            () -> assertEquals(nic, guest.getNicPassport()),
            () -> assertEquals(nationality, guest.getNationality()),
            () -> assertEquals(address, guest.getAddress()),
            () -> assertEquals(gender, guest.getGender()),
            () -> assertEquals(dob, guest.getDateOfBirth()),
            () -> assertEquals(type, guest.getGuestType()),
            () -> assertEquals(stays, guest.getTotalStays()),
            () -> assertEquals(createdAt, guest.getCreatedAt()),
            () -> assertEquals(active, guest.isActive()),
            () -> assertEquals(vip, guest.isVip()),
            () -> assertEquals(blacklisted, guest.isBlacklisted())
        );
        System.out.println("TC002: Exhaustive Setters & Getters Test - Passed");
    }

    // ─── UTILITY METHODS ──────────────────────────────────────────────────────

    @Test
    @DisplayName("TC003: Test Full Name Concatenation")
    void testFullName() {
        guest.setFirstName("Jane");
        guest.setLastName("Smith");
        assertEquals("Jane Smith", guest.getFullName());
        System.out.println("TC003: Full Name Logic - Passed");
    }

    @Test
    @DisplayName("TC004: Test Display Code (Null Safety)")
    void testDisplayCode() {
        guest.setGuestCode(null);
        assertEquals("N/A", guest.getDisplayCode(), "Should return N/A when code is null");

        guest.setGuestCode("G-999");
        assertEquals("G-999", guest.getDisplayCode(), "Should return actual code when set");
        System.out.println("TC004: Display Code Logic - Passed");
    }

    @Test
    @DisplayName("TC005: Test VIP Eligibility Logic")
    void testVipEligibility() {
        guest.setTotalStays(4);
        assertFalse(guest.isEligibleForVip(), "4 stays should NOT be eligible for VIP");

        guest.setTotalStays(5);
        assertTrue(guest.isEligibleForVip(), "5 stays SHOULD be eligible for VIP");

        guest.setTotalStays(10);
        assertTrue(guest.isEligibleForVip(), "10 stays SHOULD be eligible for VIP");
        System.out.println("TC005: VIP Eligibility Logic - Passed");
    }

    @Test
    @DisplayName("TC006: Test toString Method")
    void testToString() {
        // Setup data for toString
        guest.setId(5);
        guest.setGuestCode("G-123");
        guest.setFirstName("Tom");
        guest.setLastName("Hanks");
        guest.setEmail("tom@example.com");
        guest.setGuestType("VIP");
        guest.setTotalStays(10);
        guest.setVip(true);
        guest.setBlacklisted(false);

        String result = guest.toString();

        // Check if important fragments are in the string
        assertAll("Verify toString contains correct properties",
            () -> assertTrue(result.contains("id=5")),
            () -> assertTrue(result.contains("guestCode='G-123'")),
            () -> assertTrue(result.contains("fullName='Tom Hanks'")),
            () -> assertTrue(result.contains("email='tom@example.com'")),
            () -> assertTrue(result.contains("guestType='VIP'")),
            () -> assertTrue(result.contains("totalStays=10")),
            () -> assertTrue(result.contains("isVip=true")),
            () -> assertTrue(result.contains("blacklisted=false"))
        );
        System.out.println("TC006: toString Method - Passed");
    }
}