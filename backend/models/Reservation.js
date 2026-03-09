const mongoose = require("mongoose");

const reservationSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    copyId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Copy",
      required: true,
    },
    bookId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Book",
      required: true,
    },
    status: {
      type: String,
      enum: ["pending", "ready", "checked_out", "cancelled", "expired", "returned"],
      default: "pending",
    },
    requestedAt: {
      type: Date,
      default: Date.now,
    },
    readyUntil: {
      type: Date,
      default: null,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Reservation", reservationSchema);
