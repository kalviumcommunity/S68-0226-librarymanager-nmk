const mongoose = require("mongoose");

const branchSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    address: {
      type: String,
      required: true,
      trim: true,
    },
    hours: {
      type: String,
      default: "9 AM - 6 PM",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Branch", branchSchema);
