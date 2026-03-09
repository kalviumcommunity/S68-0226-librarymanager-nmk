const express = require("express");
const {
  createReservation,
  getMyReservations,
  cancelReservation,
} = require("../controllers/reservationController");
const { protect } = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/", protect, createReservation);
router.get("/my", protect, getMyReservations);
router.put("/:id/cancel", protect, cancelReservation);

module.exports = router;
