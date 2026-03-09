const mongoose = require("mongoose");

const bookSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true,
    },
    authors: {
      type: [String],
      required: true,
      default: [],
    },
    isbn: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    summary: {
      type: String,
      default: "",
    },
    genres: {
      type: [String],
      default: [],
    },
    coverUrl: {
      type: String,
      default: "",
    },
    publisher: {
      type: String,
      default: "",
    },
    totalCopies: {
      type: Number,
      default: 0,
    },
    availableCopies: {
      type: Number,
      default: 0,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Book", bookSchema);
