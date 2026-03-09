const Book = require("../models/Book");
const Copy = require("../models/Copy");
const Reservation = require("../models/Reservation");

const createReservation = async (req, res) => {
  try {
    const { bookId } = req.body;

    if (!bookId) {
      return res.status(400).json({ message: "bookId is required" });
    }

    const book = await Book.findById(bookId);
    if (!book) {
      return res.status(404).json({ message: "Book not found" });
    }

    const availableCopy = await Copy.findOne({
      bookId,
      copyStatus: "available",
    });

    if (!availableCopy) {
      return res.status(400).json({ message: "No available copies for this book" });
    }

    availableCopy.copyStatus = "reserved";
    await availableCopy.save();

    book.availableCopies = Math.max(0, book.availableCopies - 1);
    await book.save();

    const reservation = await Reservation.create({
      userId: req.user._id,
      copyId: availableCopy._id,
      bookId: book._id,
      status: "pending",
      requestedAt: new Date(),
    });

    const populatedReservation = await Reservation.findById(reservation._id)
      .populate("bookId", "title authors isbn coverUrl")
      .populate("copyId", "copyStatus shelfCode")
      .populate("userId", "name email");

    res.status(201).json({
      message: "Reservation created successfully",
      reservation: populatedReservation,
    });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

const getMyReservations = async (req, res) => {
  try {
    const reservations = await Reservation.find({ userId: req.user._id })
      .populate("bookId", "title authors isbn coverUrl")
      .populate({
        path: "copyId",
        populate: {
          path: "branchId",
          select: "name address",
        },
      })
      .sort({ createdAt: -1 });

    res.status(200).json({ count: reservations.length, reservations });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

const cancelReservation = async (req, res) => {
  try {
    const reservation = await Reservation.findById(req.params.id);

    if (!reservation) {
      return res.status(404).json({ message: "Reservation not found" });
    }

    if (reservation.userId.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "You can cancel only your own reservation" });
    }

    if (!["pending", "ready"].includes(reservation.status)) {
      return res.status(400).json({ message: "This reservation cannot be cancelled" });
    }

    reservation.status = "cancelled";
    await reservation.save();

    const copy = await Copy.findById(reservation.copyId);
    if (copy) {
      copy.copyStatus = "available";
      await copy.save();
    }

    const book = await Book.findById(reservation.bookId);
    if (book) {
      book.availableCopies += 1;
      await book.save();
    }

    res.status(200).json({ message: "Reservation cancelled successfully", reservation });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

module.exports = {
  createReservation,
  getMyReservations,
  cancelReservation,
};
