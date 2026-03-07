package test.service;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;
import com.app.model.SeasonalRate;
import com.app.dao.SeasonalRateDAO;
import com.app.service.SeasonalRateService;
import com.app.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class SeasonalRateServiceTest {

    private static SeasonalRateService seasonalRateService;
    private static SeasonalRateDAO     seasonalRateDAO;

    // ─── Setup before ALL tests ───────────────────────────────────────────────

    @BeforeAll
    static void setUpAll() {
        seasonalRateDAO     = new SeasonalRateDAO();
        seasonalRateService = new SeasonalRateService();
    }

    // ─── Clean table before EACH test ─────────────────────────────────────────

    @BeforeEach
    void cleanTable() throws Exception {
        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement()) {
            st.executeUpdate("DELETE FROM seasonal_rates");
            st.executeUpdate("ALTER TABLE seasonal_rates AUTO_INCREMENT = 1");
        }
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private SeasonalRate buildRate(String seasonName, int roomTypeId,
                                    LocalDate start, LocalDate end,
                                    double price, boolean active) {
        SeasonalRate rate = new SeasonalRate();
        rate.setSeasonName(seasonName);
        rate.setRoomTypeId(roomTypeId);
        rate.setStartDate(start);
        rate.setEndDate(end);
        rate.setPricePerNight(new BigDecimal(price));
        rate.setActive(active);
        return rate;
    }

    // Overload — active by default
    private SeasonalRate buildRate(String seasonName, int roomTypeId,
                                    LocalDate start, LocalDate end, double price) {
        return buildRate(seasonName, roomTypeId, start, end, price, true);
    }

    // ─── addRate() ────────────────────────────────────────────────────────────

    @Test
    @Order(1)
    @DisplayName("TC001: addRate - Success with valid data")
    void testAddRateSuccess() throws SQLException {
        // INPUT
        SeasonalRate rate = buildRate(
            "Summer Peak",
            1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        );

        // ACTUAL
        boolean result = seasonalRateService.addRate(rate);

        // ASSERT
        assertTrue(result, "Should insert successfully");

        // Verify it actually exists in DB
        List<SeasonalRate> all = seasonalRateDAO.getAllRates();
        assertEquals(1, all.size(), "One rate should exist in DB");
        assertEquals("Summer Peak", all.get(0).getSeasonName());
    }

    @Test
    @Order(2)
    @DisplayName("TC002: addRate - Success with inactive rate")
    void testAddRateInactive() throws SQLException {
        // INPUT — inactive rate
        SeasonalRate rate = buildRate(
            "Off Peak",
            1,
            LocalDate.of(2026, 2, 1),
            LocalDate.of(2026, 3, 31),
            10000,
            false
        );

        // ACTUAL
        boolean result = seasonalRateService.addRate(rate);

        // ASSERT
        assertTrue(result, "Should insert inactive rate successfully");

        SeasonalRate saved = seasonalRateDAO.getAllRates().get(0);
        assertFalse(saved.isActive(), "Rate should be stored as inactive");
    }

    @Test
    @Order(3)
    @DisplayName("TC003: addRate - Success with zero discount")
    void testAddRateZeroDiscount() throws SQLException {
        // INPUT
        SeasonalRate rate = buildRate(
            "Christmas",
            1,
            LocalDate.of(2026, 12, 20),
            LocalDate.of(2027, 1, 5),
            50000
        );
        rate.setDiscountPct(BigDecimal.ZERO);

        // ACTUAL
        boolean result = seasonalRateService.addRate(rate);

        // ASSERT
        assertTrue(result, "Should insert with zero discount");
    }

    // ─── getRateById() ────────────────────────────────────────────────────────

    @Test
    @Order(4)
    @DisplayName("TC004: getRateById - Returns correct record")
    void testGetRateById() throws SQLException {
        // INPUT
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        ));
        int insertedId = seasonalRateDAO.getAllRates().get(0).getId();

        // ACTUAL
        SeasonalRate result = seasonalRateService.getRateById(insertedId);

        // ASSERT
        assertNotNull(result, "Should return the rate");
        assertEquals("Summer Peak", result.getSeasonName());
        assertEquals(1, result.getRoomTypeId());
        assertEquals(0, new BigDecimal("25000").compareTo(result.getPricePerNight()));
    }

    @Test
    @Order(5)
    @DisplayName("TC005: getRateById - Returns null for non-existent ID")
    void testGetRateByIdNotFound() throws SQLException {
        // ACTUAL
        SeasonalRate result = seasonalRateService.getRateById(999);

        // ASSERT
        assertNull(result, "Should return null for ID that doesn't exist");
    }

    // ─── getAllRates() ────────────────────────────────────────────────────────

    @Test
    @Order(6)
    @DisplayName("TC006: getAllRates - Returns all inserted rates")
    void testGetAllRates() throws SQLException {
        // INPUT — insert 3 rates for different periods
        seasonalRateService.addRate(buildRate("Summer Peak",  1, LocalDate.of(2026, 6, 1),  LocalDate.of(2026, 8, 31),  25000));
        seasonalRateService.addRate(buildRate("Christmas",    1, LocalDate.of(2026, 12, 20), LocalDate.of(2027, 1, 5),   50000));
        seasonalRateService.addRate(buildRate("Off Peak",     1, LocalDate.of(2026, 2, 1),   LocalDate.of(2026, 3, 31),  10000));

        // ACTUAL
        List<SeasonalRate> result = seasonalRateService.getAllRates();

        // ASSERT
        assertEquals(3, result.size(), "Should return all 3 rates");
    }

    @Test
    @Order(7)
    @DisplayName("TC007: getAllRates - Returns empty when table is empty")
    void testGetAllRatesEmpty() throws SQLException {
        // ACTUAL — table already cleaned in @BeforeEach
        List<SeasonalRate> result = seasonalRateService.getAllRates();

        // ASSERT
        assertTrue(result.isEmpty(), "Should return empty list");
    }

    // ─── searchRates() ────────────────────────────────────────────────────────

    @Test
    @Order(8)
    @DisplayName("TC008: searchRates - Finds matching rate by season name")
    void testSearchRatesFound() throws SQLException {
        // INPUT
        seasonalRateService.addRate(buildRate("Summer Peak", 1, LocalDate.of(2026, 6, 1),  LocalDate.of(2026, 8, 31),  25000));
        seasonalRateService.addRate(buildRate("Christmas",   1, LocalDate.of(2026, 12, 20), LocalDate.of(2027, 1, 5),  50000));

        // ACTUAL
        List<SeasonalRate> result = seasonalRateService.searchRates("Summer");

        // ASSERT
        assertEquals(1, result.size(), "Should return 1 matching rate");
        assertEquals("Summer Peak", result.get(0).getSeasonName());
    }

    @Test
    @Order(9)
    @DisplayName("TC009: searchRates - Null keyword returns all rates")
    void testSearchRatesNullKeyword() throws SQLException {
        // INPUT
        seasonalRateService.addRate(buildRate("Summer Peak", 1, LocalDate.of(2026, 6, 1),  LocalDate.of(2026, 8, 31),  25000));
        seasonalRateService.addRate(buildRate("Christmas",   1, LocalDate.of(2026, 12, 20), LocalDate.of(2027, 1, 5),  50000));

        // ACTUAL
        List<SeasonalRate> result = seasonalRateService.searchRates(null);

        // ASSERT
        assertEquals(2, result.size(), "Null keyword should return all rates");
    }

    @Test
    @Order(10)
    @DisplayName("TC010: searchRates - Empty keyword returns all rates")
    void testSearchRatesEmptyKeyword() throws SQLException {
        // INPUT
        seasonalRateService.addRate(buildRate("Summer Peak", 1, LocalDate.of(2026, 6, 1), LocalDate.of(2026, 8, 31), 25000));

        // ACTUAL
        List<SeasonalRate> result = seasonalRateService.searchRates("   ");

        // ASSERT
        assertEquals(1, result.size(), "Empty keyword should return all rates");
    }

    @Test
    @Order(11)
    @DisplayName("TC011: searchRates - No match returns empty list")
    void testSearchRatesNoMatch() throws SQLException {
        // INPUT
        seasonalRateService.addRate(buildRate("Summer Peak", 1, LocalDate.of(2026, 6, 1), LocalDate.of(2026, 8, 31), 25000));

        // ACTUAL
        List<SeasonalRate> result = seasonalRateService.searchRates("Monsoon");

        // ASSERT
        assertTrue(result.isEmpty(), "Should return empty when no match found");
    }

    // ─── updateRate() ─────────────────────────────────────────────────────────

    @Test
    @Order(12)
    @DisplayName("TC012: updateRate - Successfully updates record")
    void testUpdateRateSuccess() throws SQLException {
        // INPUT — insert then update
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        ));
        SeasonalRate existing = seasonalRateDAO.getAllRates().get(0);

        // Modify fields
        existing.setSeasonName("Summer Peak 2026");
        existing.setPricePerNight(new BigDecimal("30000"));

        // ACTUAL
        boolean result = seasonalRateService.updateRate(existing);

        // ASSERT
        assertTrue(result, "Should update successfully");

        // Verify change persisted in DB
        SeasonalRate updated = seasonalRateDAO.getRateById(existing.getId());
        assertEquals("Summer Peak 2026", updated.getSeasonName());
        assertEquals(0, new BigDecimal("30000").compareTo(updated.getPricePerNight()));
    }

    @Test
    @Order(13)
    @DisplayName("TC013: updateRate - Toggle active status")
    void testUpdateRateToggleActive() throws SQLException {
        // INPUT — insert active rate then deactivate
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000,
            true
        ));
        SeasonalRate existing = seasonalRateDAO.getAllRates().get(0);
        assertTrue(existing.isActive(), "Should be active initially");

        // Deactivate
        existing.setActive(false);
        seasonalRateService.updateRate(existing);

        // ASSERT
        SeasonalRate updated = seasonalRateDAO.getRateById(existing.getId());
        assertFalse(updated.isActive(), "Should be inactive after update");
    }

    // ─── deleteRate() ─────────────────────────────────────────────────────────

    @Test
    @Order(14)
    @DisplayName("TC014: deleteRate - Successfully deletes rate")
    void testDeleteRateSuccess() throws SQLException {
        // INPUT
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        ));
        SeasonalRate rate = seasonalRateDAO.getAllRates().get(0);

        // ACTUAL
        boolean result = seasonalRateService.deleteRate(rate.getId());

        // ASSERT
        assertTrue(result, "Should delete successfully");

        // Verify gone from DB
        assertNull(seasonalRateDAO.getRateById(rate.getId()),
            "Rate should not exist after delete");
    }

    @Test
    @Order(15)
    @DisplayName("TC015: deleteRate - Returns false for non-existent ID")
    void testDeleteRateNotFound() throws SQLException {
        // ACTUAL
        boolean result = seasonalRateService.deleteRate(999);

        // ASSERT
        assertFalse(result, "Should return false when ID does not exist");
    }

    // ─── hasOverlappingRates() ────────────────────────────────────────────────

    @Test
    @Order(16)
    @DisplayName("TC016: hasOverlappingRates - Detects exact same date range")
    void testOverlapExactSameDates() throws SQLException {
        // INPUT — insert a rate for June–August
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        ));

        // ACTUAL — try same range for same room type
        boolean overlaps = seasonalRateService.hasOverlappingRates(
            1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            null
        );

        // ASSERT
        assertTrue(overlaps, "Exact same date range should be detected as overlap");
    }

    @Test
    @Order(17)
    @DisplayName("TC017: hasOverlappingRates - Detects partial overlap (starts inside)")
    void testOverlapStartsInside() throws SQLException {
        // INPUT
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        ));

        // New rate starts inside existing range
        boolean overlaps = seasonalRateService.hasOverlappingRates(
            1,
            LocalDate.of(2026, 7, 15),
            LocalDate.of(2026, 9, 30),
            null
        );

        // ASSERT
        assertTrue(overlaps, "Rate starting inside existing range should overlap");
    }

    @Test
    @Order(18)
    @DisplayName("TC018: hasOverlappingRates - Detects partial overlap (ends inside)")
    void testOverlapEndsInside() throws SQLException {
        // INPUT
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        ));

        // New rate ends inside existing range
        boolean overlaps = seasonalRateService.hasOverlappingRates(
            1,
            LocalDate.of(2026, 5, 1),
            LocalDate.of(2026, 7, 15),
            null
        );

        // ASSERT
        assertTrue(overlaps, "Rate ending inside existing range should overlap");
    }

    @Test
    @Order(19)
    @DisplayName("TC019: hasOverlappingRates - No overlap for different period")
    void testNoOverlapDifferentPeriod() throws SQLException {
        // INPUT
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        ));

        // New rate is completely outside
        boolean overlaps = seasonalRateService.hasOverlappingRates(
            1,
            LocalDate.of(2026, 9, 1),
            LocalDate.of(2026, 11, 30),
            null
        );

        // ASSERT
        assertFalse(overlaps, "Non-overlapping date range should return false");
    }

    @Test
    @Order(20)
    @DisplayName("TC020: hasOverlappingRates - No overlap for different room type")
    void testNoOverlapDifferentRoomType() throws SQLException {
        // INPUT — rate exists for room type 1
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        ));

        // Check overlap for room type 2 — same dates but different type
        boolean overlaps = seasonalRateService.hasOverlappingRates(
            2,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            null
        );

        // ASSERT
        assertFalse(overlaps, "Same dates but different room type should NOT overlap");
    }

    @Test
    @Order(21)
    @DisplayName("TC021: hasOverlappingRates - Excludes self when updating")
    void testNoOverlapExcludesSelf() throws SQLException {
        // INPUT — insert a rate
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        ));
        int existingId = seasonalRateDAO.getAllRates().get(0).getId();

        // ACTUAL — check overlap excluding own ID (update scenario)
        boolean overlaps = seasonalRateService.hasOverlappingRates(
            1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            existingId // exclude self
        );

        // ASSERT
        assertFalse(overlaps, "Should not flag overlap with itself during update");
    }

    @Test
    @Order(22)
    @DisplayName("TC022: hasOverlappingRates - Detects overlap spanning entire existing range")
    void testOverlapSpansEntireExisting() throws SQLException {
        // INPUT
        seasonalRateService.addRate(buildRate(
            "Summer Peak", 1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            25000
        ));

        // New rate completely wraps the existing one
        boolean overlaps = seasonalRateService.hasOverlappingRates(
            1,
            LocalDate.of(2026, 5, 1),
            LocalDate.of(2026, 10, 31),
            null
        );

        // ASSERT
        assertTrue(overlaps, "Rate wrapping entire existing range should overlap");
    }

    @Test
    @Order(23)
    @DisplayName("TC023: hasOverlappingRates - No overlap when table is empty")
    void testNoOverlapEmptyTable() throws SQLException {
        // ACTUAL — no rates in DB
        boolean overlaps = seasonalRateService.hasOverlappingRates(
            1,
            LocalDate.of(2026, 6, 1),
            LocalDate.of(2026, 8, 31),
            null
        );

        // ASSERT
        assertFalse(overlaps, "Should return false when no rates exist");
    }
}