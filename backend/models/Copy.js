const mongoose = require("mongoose");

const copySchema = new mongoose.Schema(
  {
    bookId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Book",
      required: true,
    },
    branchId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Branch",
      required: true,
    },
    shelfCode: {
      type: String,
      default: "",
    },
    copyStatus: {
      type: String,
      enum: ["available", "reserved", "checked_out", "lost", "damaged"],
      default: "available",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Copy", copySchema);
