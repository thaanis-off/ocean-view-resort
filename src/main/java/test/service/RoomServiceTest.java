package test.service;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;
import com.app.model.Room;
import com.app.dao.RoomDAO;
import com.app.service.RoomService;
import com.app.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.List;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class RoomServiceTest {

    private static RoomService roomService;
    private static RoomDAO     roomDAO;

    @BeforeAll
    static void setUpAll() {
        roomDAO     = new RoomDAO();
        roomService = new RoomService();
    }

    @BeforeEach
    void cleanTable() throws Exception {
        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement()) {
            st.executeUpdate("DELETE FROM rooms");
            st.executeUpdate("ALTER TABLE rooms AUTO_INCREMENT = 1");
        }
    }

    // ─── Helpers ──────────────────────────────────────────────────────────────

    private Room buildRoom(String roomNumber, int floor, int roomTypeId, String status, String viewType, boolean isActive) {
        Room room = new Room();
        room.setRoomNumber(roomNumber);
        room.setRoomTypeId(roomTypeId);
        room.setFloorNumber(floor);
        room.setViewType(viewType);
        room.setStatus(status);
        room.setActive(true);
        return room;
    }

    // Overload — default viewType so existing calls with 4 params work
    private Room buildRoom(String roomNumber, int floor, int roomTypeId, String status) {
        return buildRoom(roomNumber, floor, roomTypeId, status, "Garden View", true);
    }

    // ─── addRoom() ────────────────────────────────────────────────────────────

    @Test
    @Order(1)
    @DisplayName("TC001: addRoom - Success with unique room number")
    void testAddRoomSuccess() throws SQLException {
        Room room = buildRoom("101", 1, 1, "Available", "Sea View", true);

        boolean result = roomService.addRoom(room);

        assertTrue(result, "Should insert successfully");
        Room saved = roomDAO.getRoomByNumber("101");
        assertNotNull(saved, "Should be found in DB after insert");
        assertEquals("101", saved.getRoomNumber());
        assertEquals(1, saved.getFloorNumber());
    }

    @Test
    @Order(2)
    @DisplayName("TC002: addRoom - Blocked on duplicate room number")
    void testAddRoomDuplicateNumber() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available", "Sea View", true));

        boolean result = roomService.addRoom(buildRoom("101", 1, 1, "Available", "Sea View" , true));

        assertFalse(result, "Should block duplicate room number");
        assertEquals(1, roomDAO.getAllRooms().size(), "Only one room should exist");
    }

    // ─── getRoomById() ────────────────────────────────────────────────────────

    @Test
    @Order(3)
    @DisplayName("TC003: getRoomById - Returns correct record")
    void testGetRoomById() throws SQLException {
        // INPUT — insert 202, look up 202 ✅
        roomService.addRoom(buildRoom("202", 2, 1, "Available", "Sea View", true));
        Room inserted = roomDAO.getRoomByNumber("202");

        Room result = roomService.getRoomById(inserted.getId());

        assertNotNull(result);
        assertEquals("202", result.getRoomNumber());
        assertEquals(2, result.getFloorNumber());
    }

    @Test
    @Order(4)
    @DisplayName("TC004: getRoomById - Returns null for non-existent ID")
    void testGetRoomByIdNotFound() throws SQLException {
        Room result = roomService.getRoomById(999);

        assertNull(result, "Should return null for ID that doesn't exist");
    }

    // ─── getRoomByNumber() ────────────────────────────────────────────────────

    @Test
    @Order(5)
    @DisplayName("TC005: getRoomByNumber - Returns correct room")
    void testGetRoomByNumber() throws SQLException {
        // INPUT — insert 305, look up 305 ✅
        roomService.addRoom(buildRoom("305", 3, 1, "Available", "Sea View", true));

        Room result = roomService.getRoomByNumber("305");

        assertNotNull(result);
        assertEquals("305", result.getRoomNumber());
    }

    @Test
    @Order(6)
    @DisplayName("TC006: getRoomByNumber - Returns null when not found")
    void testGetRoomByNumberNotFound() throws SQLException {
        Room result = roomService.getRoomByNumber("999");

        assertNull(result, "Should return null for non-existent room number");
    }

    // ─── getAllRooms() ────────────────────────────────────────────────────────

    @Test
    @Order(7)
    @DisplayName("TC007: getAllRooms - Returns all inserted rooms")
    void testGetAllRooms() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available", "Sea View", true));
        roomService.addRoom(buildRoom("202", 2, 1, "Available", "Sea View", true));
        roomService.addRoom(buildRoom("303", 3, 1, "Available", "Sea View", true));

        List<Room> result = roomService.getAllRooms();

        assertEquals(3, result.size(), "Should return all 3 rooms");
    }

    @Test
    @Order(8)
    @DisplayName("TC008: getAllRooms - Returns empty when table is empty")
    void testGetAllRoomsEmpty() throws SQLException {
        List<Room> result = roomService.getAllRooms();

        assertTrue(result.isEmpty(), "Should return empty list");
    }

    // ─── getRoomsByStatus() ───────────────────────────────────────────────────

    @Test
    @Order(9)
    @DisplayName("TC009: getRoomsByStatus - Returns only matching status rooms")
    void testGetRoomsByStatus() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        roomService.addRoom(buildRoom("102", 1, 1, "Available"));
        roomService.addRoom(buildRoom("201", 2, 1, "Occupied"));

        List<Room> available = roomService.getRoomsByStatus("Available");
        List<Room> occupied  = roomService.getRoomsByStatus("Occupied");

        assertEquals(2, available.size(), "Should return 2 available rooms");
        assertEquals(1, occupied.size(),  "Should return 1 occupied room");
    }

    @Test
    @Order(10)
    @DisplayName("TC010: getRoomsByStatus - Returns empty for status with no rooms")
    void testGetRoomsByStatusNoMatch() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));

        List<Room> result = roomService.getRoomsByStatus("Maintenance");

        assertTrue(result.isEmpty(), "Should return empty for unmatched status");
    }

    // ─── getRoomsByFloor() ────────────────────────────────────────────────────

    @Test
    @Order(11)
    @DisplayName("TC011: getRoomsByFloor - Returns rooms on correct floor")
    void testGetRoomsByFloor() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        roomService.addRoom(buildRoom("102", 1, 1, "Available"));
        roomService.addRoom(buildRoom("201", 2, 1, "Available"));

        List<Room> floor1 = roomService.getRoomsByFloor(1);
        List<Room> floor2 = roomService.getRoomsByFloor(2);

        assertEquals(2, floor1.size(), "Should return 2 rooms on floor 1");
        assertEquals(1, floor2.size(), "Should return 1 room on floor 2");
    }

    // ─── searchRooms() ────────────────────────────────────────────────────────

    @Test
    @Order(12)
    @DisplayName("TC012: searchRooms - Finds matching room")
    void testSearchRoomsFound() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        roomService.addRoom(buildRoom("202", 2, 1, "Available"));

        List<Room> result = roomService.searchRooms("101");

        assertEquals(1, result.size());
        assertEquals("101", result.get(0).getRoomNumber());
    }

    @Test
    @Order(13)
    @DisplayName("TC013: searchRooms - Null keyword returns all rooms")
    void testSearchRoomsNullKeyword() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        roomService.addRoom(buildRoom("202", 2, 1, "Available"));

        List<Room> result = roomService.searchRooms(null);

        assertEquals(2, result.size(), "Null keyword should return all rooms");
    }

    @Test
    @Order(14)
    @DisplayName("TC014: searchRooms - Empty keyword returns all rooms")
    void testSearchRoomsEmptyKeyword() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));

        List<Room> result = roomService.searchRooms("   ");

        assertEquals(1, result.size(), "Empty keyword should return all rooms");
    }

    @Test
    @Order(15)
    @DisplayName("TC015: searchRooms - No match returns empty list")
    void testSearchRoomsNoMatch() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));

        List<Room> result = roomService.searchRooms("999");

        assertTrue(result.isEmpty(), "Should return empty when no match found");
    }

    // ─── updateRoom() ─────────────────────────────────────────────────────────

    @Test
    @Order(16)
    @DisplayName("TC016: updateRoom - Successfully updates record")
    void testUpdateRoomSuccess() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        Room existing = roomDAO.getRoomByNumber("101");
        existing.setFloorNumber(3);
        existing.setRoomNumber("301");

        boolean result = roomService.updateRoom(existing);

        assertTrue(result, "Should update successfully");
        Room updated = roomDAO.getRoomById(existing.getId());
        assertEquals("301", updated.getRoomNumber());
        assertEquals(3,     updated.getFloorNumber());
    }

    @Test
    @Order(17)
    @DisplayName("TC017: updateRoom - Blocked when room number taken by another room")
    void testUpdateRoomDuplicateNumber() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        roomService.addRoom(buildRoom("202", 2, 1, "Available"));

        Room room101 = roomDAO.getRoomByNumber("101");
        room101.setRoomNumber("202");

        boolean result = roomService.updateRoom(room101);

        assertFalse(result, "Should block update when room number is taken");
    }

    // ─── updateRoomStatus() ───────────────────────────────────────────────────

    @Test
    @Order(18)
    @DisplayName("TC018: updateRoomStatus - Successfully changes status")
    void testUpdateRoomStatus() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        Room room = roomDAO.getRoomByNumber("101");

        boolean result = roomService.updateRoomStatus(room.getId(), "Occupied");

        assertTrue(result, "Should update status successfully");
        assertEquals("Occupied", roomDAO.getRoomById(room.getId()).getStatus());
    }

    // ─── deleteRoom() ─────────────────────────────────────────────────────────

    @Test
    @Order(19)
    @DisplayName("TC019: deleteRoom - Successfully deletes available room")
    void testDeleteRoomSuccess() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        Room room = roomDAO.getRoomByNumber("101");

        boolean result = roomService.deleteRoom(room.getId());

        assertTrue(result, "Should delete available room");
        assertNull(roomDAO.getRoomById(room.getId()), "Should not exist after delete");
    }

    @Test
    @Order(20)
    @DisplayName("TC020: deleteRoom - Blocked when room is Occupied")
    void testDeleteRoomBlockedWhenOccupied() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Occupied"));
        Room room = roomDAO.getRoomByNumber("101");

        boolean result = roomService.deleteRoom(room.getId());

        assertFalse(result, "Should NOT delete an occupied room");
        assertNotNull(roomDAO.getRoomById(room.getId()), "Room should still exist");
    }

    // ─── roomNumberExists() ───────────────────────────────────────────────────

    @Test
    @Order(21)
    @DisplayName("TC021: roomNumberExists - Returns true when exists")
    void testRoomNumberExistsTrue() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));

        assertTrue(roomService.roomNumberExists("101"));
    }

    @Test
    @Order(22)
    @DisplayName("TC022: roomNumberExists - Returns false when not exists")
    void testRoomNumberExistsFalse() throws SQLException {
        assertFalse(roomService.roomNumberExists("999"),
            "Should return false for non-existent room number");
    }

    // ─── getAvailableRooms() ──────────────────────────────────────────────────

    @Test
    @Order(23)
    @DisplayName("TC023: getAvailableRooms - Returns only available rooms")
    void testGetAvailableRooms() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        roomService.addRoom(buildRoom("102", 1, 1, "Available"));
        roomService.addRoom(buildRoom("201", 2, 1, "Occupied"));
        roomService.addRoom(buildRoom("301", 3, 1, "Maintenance"));

        List<Room> result = roomService.getAvailableRooms();

        assertEquals(2, result.size(), "Should return only 2 available rooms");
        result.forEach(r ->
            assertEquals("Available", r.getStatus(), "All returned rooms should be Available")
        );
    }

    // ─── getRoomCountByStatus() ───────────────────────────────────────────────

    @Test
    @Order(24)
    @DisplayName("TC024: getRoomCountByStatus - Returns correct count")
    void testGetRoomCountByStatus() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        roomService.addRoom(buildRoom("102", 1, 1, "Available"));
        roomService.addRoom(buildRoom("201", 2, 1, "Occupied"));

        int availableCount = roomService.getRoomCountByStatus("Available");
        int occupiedCount  = roomService.getRoomCountByStatus("Occupied");

        assertEquals(2, availableCount, "Should count 2 available rooms");
        assertEquals(1, occupiedCount,  "Should count 1 occupied room");
    }

    // ─── Status Transition Helpers ────────────────────────────────────────────

    @Test
    @Order(25)
    @DisplayName("TC025: markAsAvailable - Changes status to Available")
    void testMarkAsAvailable() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Occupied"));
        Room room = roomDAO.getRoomByNumber("101");

        assertTrue(roomService.markAsAvailable(room.getId()));
        assertEquals("Available", roomDAO.getRoomById(room.getId()).getStatus());
    }

    @Test
    @Order(26)
    @DisplayName("TC026: markAsOccupied - Changes status to Occupied")
    void testMarkAsOccupied() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        Room room = roomDAO.getRoomByNumber("101");

        assertTrue(roomService.markAsOccupied(room.getId()));
        assertEquals("Occupied", roomDAO.getRoomById(room.getId()).getStatus());
    }

    @Test
    @Order(27)
    @DisplayName("TC027: markAsMaintenance - Changes status to Maintenance")
    void testMarkAsMaintenance() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        Room room = roomDAO.getRoomByNumber("101");

        assertTrue(roomService.markAsMaintenance(room.getId()));
        assertEquals("Maintenance", roomDAO.getRoomById(room.getId()).getStatus());
    }

    @Test
    @Order(28)
    @DisplayName("TC028: markAsReserved - Changes status to Reserved")
    void testMarkAsReserved() throws SQLException {
        roomService.addRoom(buildRoom("101", 1, 1, "Available"));
        Room room = roomDAO.getRoomByNumber("101");

        assertTrue(roomService.markAsReserved(room.getId()));
        assertEquals("Reserved", roomDAO.getRoomById(room.getId()).getStatus());
    }
}