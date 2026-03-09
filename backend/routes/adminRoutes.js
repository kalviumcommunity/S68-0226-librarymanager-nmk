const express = require("express");
const {
  createBranch,
  addCopy,
  updateCopyStatus,
  getAllReservations,
  updateReservationStatus,
  getAnalytics,
} = require("../controllers/adminController");
const { protect } = require("../middleware/authMiddleware");
const allowRoles = require("../middleware/roleMiddleware");

const router = express.Router();

router.use(protect, allowRoles("admin", "staff"));

router.post("/branches", createBranch);
router.post("/copies", addCopy);
router.put("/copies/:id/status", updateCopyStatus);
router.get("/reservations", getAllReservations);
router.put("/reservations/:id/status", updateReservationStatus);
router.get("/analytics", getAnalytics);

module.exports = router;
