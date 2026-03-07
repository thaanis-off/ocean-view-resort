package test.service;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.*;

import com.app.model.RoomType;
import com.app.dao.RoomTypeDAO;
import com.app.service.RoomTypeService;

import com.app.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.List;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class RoomTypeServiceTest {

    private static RoomTypeService roomTypeService;
    private static RoomTypeDAO     roomTypeDAO;

    // ─── Setup before ALL tests ───────────────────────────────────────────────

    @BeforeAll
    static void setUpAll() {
        roomTypeDAO     = new RoomTypeDAO();
        roomTypeService = new RoomTypeService();
    }

    // ─── Clean table before EACH test ─────────────────────────────────────────

    @BeforeEach
    void cleanTable() throws Exception {
        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement()) {
            st.executeUpdate("DELETE FROM room_types");
            st.executeUpdate("ALTER TABLE room_types AUTO_INCREMENT = 1");
        }
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private RoomType buildRoomType(String name, double price, int occupancy) {
        RoomType rt = new RoomType();
        rt.setTypeName(name);
        rt.setDescription("Test description");
        rt.setBasePrice(new BigDecimal(price));
        rt.setMaxOccupancy(occupancy);
        rt.setAmenities("WiFi, AC");
        return rt;
    }

    // ─── addRoomType() ────────────────────────────────────────────────────────

    @Test
    @Order(1)
    @DisplayName("TC001: addRoomType - Success with unique name")
    void testAddRoomTypeSuccess() throws SQLException {
        // INPUT
        RoomType rt = buildRoomType("Deluxe", 15000, 3);

        // ACTUAL
        boolean result = roomTypeService.addRoomType(rt);

        // ASSERT
        assertTrue(result, "Should insert successfully");

        // Verify it actually exists in DB
        RoomType saved = roomTypeDAO.getRoomTypeByName("Deluxe");
        assertNotNull(saved, "Should be found in DB after insert");
        assertEquals("Deluxe", saved.getTypeName());
    }

    @Test
    @Order(2)
    @DisplayName("TC002: addRoomType - Blocked on duplicate name")
    void testAddRoomTypeDuplicateName() throws SQLException {
        // INPUT — insert first one
        roomTypeService.addRoomType(buildRoomType("Deluxe", 15000, 3));

        // Try inserting same name again
        boolean result = roomTypeService.addRoomType(buildRoomType("Deluxe", 18000, 4));

        // ASSERT
        assertFalse(result, "Should block duplicate type name");
    }

    // ─── getRoomTypeById() ────────────────────────────────────────────────────

    @Test
    @Order(3)
    @DisplayName("TC003: getRoomTypeById - Returns correct record")
    void testGetRoomTypeById() throws SQLException {
        // INPUT — insert and get the generated ID
        roomTypeService.addRoomType(buildRoomType("Standard", 8000, 2));
        RoomType inserted = roomTypeDAO.getRoomTypeByName("Standard");

        // ACTUAL
        RoomType result = roomTypeService.getRoomTypeById(inserted.getId());

        // ASSERT
        assertNotNull(result);
        assertEquals("Standard", result.getTypeName());
        assertEquals(2, result.getMaxOccupancy());
    }

    @Test
    @Order(4)
    @DisplayName("TC004: getRoomTypeById - Returns null for non-existent ID")
    void testGetRoomTypeByIdNotFound() throws SQLException {
        // ACTUAL
        RoomType result = roomTypeService.getRoomTypeById(999);

        // ASSERT
        assertNull(result, "Should return null for ID that doesn't exist");
    }

    // ─── getAllRoomTypes() ────────────────────────────────────────────────────

    @Test
    @Order(5)
    @DisplayName("TC005: getAllRoomTypes - Returns all inserted records")
    void testGetAllRoomTypes() throws SQLException {
        // INPUT — insert 3 types
        roomTypeService.addRoomType(buildRoomType("Standard", 8000, 2));
        roomTypeService.addRoomType(buildRoomType("Deluxe",   15000, 3));
        roomTypeService.addRoomType(buildRoomType("Suite",    25000, 4));

        // ACTUAL
        List<RoomType> result = roomTypeService.getAllRoomTypes();

        // ASSERT
        assertEquals(3, result.size(), "Should return all 3 room types");
    }

    @Test
    @Order(6)
    @DisplayName("TC006: getAllRoomTypes - Returns empty when table is empty")
    void testGetAllRoomTypesEmpty() throws SQLException {
        // ACTUAL — table already cleaned in @BeforeEach
        List<RoomType> result = roomTypeService.getAllRoomTypes();

        // ASSERT
        assertTrue(result.isEmpty(), "Should return empty list");
    }

    // ─── searchRoomTypes() ────────────────────────────────────────────────────

    @Test
    @Order(7)
    @DisplayName("TC007: searchRoomTypes - Finds matching record")
    void testSearchRoomTypesFound() throws SQLException {
        // INPUT
        roomTypeService.addRoomType(buildRoomType("Ocean Deluxe", 20000, 3));
        roomTypeService.addRoomType(buildRoomType("Standard",     8000,  2));

        // ACTUAL
        List<RoomType> result = roomTypeService.searchRoomTypes("Ocean");

        // ASSERT
        assertEquals(1, result.size());
        assertEquals("Ocean Deluxe", result.get(0).getTypeName());
    }

    @Test
    @Order(8)
    @DisplayName("TC008: searchRoomTypes - Null keyword returns all")
    void testSearchRoomTypesNullKeyword() throws SQLException {
        // INPUT
        roomTypeService.addRoomType(buildRoomType("Standard", 8000, 2));
        roomTypeService.addRoomType(buildRoomType("Deluxe",   15000, 3));

        // ACTUAL
        List<RoomType> result = roomTypeService.searchRoomTypes(null);

        // ASSERT
        assertEquals(2, result.size(), "Null keyword should return all room types");
    }

    @Test
    @Order(9)
    @DisplayName("TC009: searchRoomTypes - No match returns empty list")
    void testSearchRoomTypesNoMatch() throws SQLException {
        // INPUT
        roomTypeService.addRoomType(buildRoomType("Standard", 8000, 2));

        // ACTUAL
        List<RoomType> result = roomTypeService.searchRoomTypes("Penthouse");

        // ASSERT
        assertTrue(result.isEmpty(), "Should return empty when no match found");
    }

    // ─── updateRoomType() ────────────────────────────────────────────────────

    @Test
    @Order(10)
    @DisplayName("TC010: updateRoomType - Successfully updates record")
    void testUpdateRoomTypeSuccess() throws SQLException {
        // INPUT — insert then update
        roomTypeService.addRoomType(buildRoomType("Deluxe", 15000, 3));
        RoomType existing = roomTypeDAO.getRoomTypeByName("Deluxe");

        existing.setTypeName("Deluxe Plus");
        existing.setBasePrice(new BigDecimal("18000"));

        // ACTUAL
        boolean result = roomTypeService.updateRoomType(existing);

        // ASSERT
        assertTrue(result, "Should update successfully");

        // Verify change persisted in DB
        RoomType updated = roomTypeDAO.getRoomTypeById(existing.getId());
        assertEquals("Deluxe Plus", updated.getTypeName());
        assertEquals(0, new BigDecimal("18000").compareTo(updated.getBasePrice()));
    }

    @Test
    @Order(11)
    @DisplayName("TC011: updateRoomType - Blocked when name taken by another type")
    void testUpdateRoomTypeDuplicateName() throws SQLException {
        // INPUT — insert two types
        roomTypeService.addRoomType(buildRoomType("Standard", 8000, 2));
        roomTypeService.addRoomType(buildRoomType("Deluxe",   15000, 3));

        // Try renaming Standard → Deluxe (already taken)
        RoomType standard = roomTypeDAO.getRoomTypeByName("Standard");
        standard.setTypeName("Deluxe");

        // ACTUAL
        boolean result = roomTypeService.updateRoomType(standard);

        // ASSERT
        assertFalse(result, "Should block update when name is taken by another type");
    }

    // ─── deleteRoomType() ────────────────────────────────────────────────────

    @Test
    @Order(12)
    @DisplayName("TC012: deleteRoomType - Successfully deletes unused type")
    void testDeleteRoomTypeSuccess() throws SQLException {
        // INPUT
        roomTypeService.addRoomType(buildRoomType("Deluxe", 15000, 3));
        RoomType rt = roomTypeDAO.getRoomTypeByName("Deluxe");

        // ACTUAL
        boolean result = roomTypeService.deleteRoomType(rt.getId());

        // ASSERT
        assertTrue(result, "Should delete when no rooms are linked");

        // Verify gone from DB
        assertNull(roomTypeDAO.getRoomTypeById(rt.getId()), "Should not exist after delete");
    }

    @Test
    @Order(13)
    @DisplayName("TC013: typeNameExists - Returns true when exists")
    void testTypeNameExistsTrue() throws SQLException {
        // INPUT
        roomTypeService.addRoomType(buildRoomType("Suite", 25000, 4));

        // ACTUAL + ASSERT
        assertTrue(roomTypeService.typeNameExists("Suite"));
    }

    @Test
    @Order(14)
    @DisplayName("TC014: typeNameExists - Returns false when not exists")
    void testTypeNameExistsFalse() throws SQLException {
        // ACTUAL + ASSERT
        assertFalse(roomTypeService.typeNameExists("Penthouse"),
            "Should return false for non-existent type name");
    }

    @Test
    @Order(15)
    @DisplayName("TC015: getRoomCountByType - Returns zero for new type")
    void testGetRoomCountByTypeZero() throws SQLException {
        // INPUT
        roomTypeService.addRoomType(buildRoomType("Standard", 8000, 2));
        RoomType rt = roomTypeDAO.getRoomTypeByName("Standard");

        // ACTUAL
        int count = roomTypeService.getRoomCountByType(rt.getId());

        // ASSERT
        assertEquals(0, count, "New room type should have zero rooms");
    }
}