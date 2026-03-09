const Book = require("../models/Book");
const Branch = require("../models/Branch");
const Copy = require("../models/Copy");
const Reservation = require("../models/Reservation");
const User = require("../models/User");

const createBranch = async (req, res) => {
  try {
    const { name, address, hours } = req.body;

    if (!name || !address) {
      return res.status(400).json({ message: "Name and address are required" });
    }

    const branch = await Branch.create({
      name,
      address,
      hours: hours || "9 AM - 6 PM",
    });

    res.status(201).json({ message: "Branch created successfully", branch });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

const addCopy = async (req, res) => {
  try {
    const { bookId, branchId, shelfCode } = req.body;

    if (!bookId || !branchId) {
      return res.status(400).json({ message: "bookId and branchId are required" });
    }

    const book = await Book.findById(bookId);
    const branch = await Branch.findById(branchId);

    if (!book) {
      return res.status(404).json({ message: "Book not found" });
    }

    if (!branch) {
      return res.status(404).json({ message: "Branch not found" });
    }

    const copy = await Copy.create({
      bookId,
      branchId,
      shelfCode: shelfCode || "",
      copyStatus: "available",
    });

    book.totalCopies += 1;
    book.availableCopies += 1;
    await book.save();

    res.status(201).json({ message: "Copy added successfully", copy });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

const updateCopyStatus = async (req, res) => {
  try {
    const { copyStatus } = req.body;

    const copy = await Copy.findById(req.params.id);
    if (!copy) {
      return res.status(404).json({ message: "Copy not found" });
    }

    const oldStatus = copy.copyStatus;
    copy.copyStatus = copyStatus;
    await copy.save();

    const book = await Book.findById(copy.bookId);
    if (book) {
      if (oldStatus !== "available" && copyStatus === "available") {
        book.availableCopies += 1;
      } else if (oldStatus === "available" && copyStatus != "available") {
        book.availableCopies = Math.max(0, book.availableCopies - 1);
      }
      await book.save();
    }

    res.status(200).json({ message: "Copy status updated successfully", copy });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

const getAllReservations = async (req, res) => {
  try {
    const reservations = await Reservation.find()
      .populate("userId", "name email role")
      .populate("bookId", "title authors isbn")
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

const updateReservationStatus = async (req, res) => {
  try {
    const { status } = req.body;

    const reservation = await Reservation.findById(req.params.id);
    if (!reservation) {
      return res.status(404).json({ message: "Reservation not found" });
    }

    const previousStatus = reservation.status;
    reservation.status = status;

    if (status === "ready") {
      const readyUntil = new Date();
      readyUntil.setDate(readyUntil.getDate() + 3);
      reservation.readyUntil = readyUntil;
    }

    const terminalStatuses = ["returned", "cancelled", "expired"];
    if (terminalStatuses.includes(status) && !terminalStatuses.includes(previousStatus)) {
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
    }

    if (status === "checked_out") {
      const copy = await Copy.findById(reservation.copyId);
      if (copy) {
        copy.copyStatus = "checked_out";
        await copy.save();
      }
    }

    await reservation.save();

    res.status(200).json({
      message: "Reservation status updated successfully",
      reservation,
    });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

const getAnalytics = async (req, res) => {
  try {
    const totalUsers = await User.countDocuments();
    const totalBooks = await Book.countDocuments();
    const totalCopies = await Copy.countDocuments();
    const activeReservations = await Reservation.countDocuments({
      status: { $in: ["pending", "ready", "checked_out"] },
    });

    const mostRequested = await Reservation.aggregate([
      {
        $group: {
          _id: "$bookId",
          count: { $sum: 1 },
        },
      },
      { $sort: { count: -1 } },
      { $limit: 10 },
    ]);

    const populatedMostRequested = await Book.populate(mostRequested, {
      path: "_id",
      select: "title authors isbn",
    });

    res.status(200).json({
      totalUsers,
      totalBooks,
      totalCopies,
      activeReservations,
      mostRequested: populatedMostRequested,
    });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

module.exports = {
  createBranch,
  addCopy,
  updateCopyStatus,
  getAllReservations,
  updateReservationStatus,
  getAnalytics,
};
