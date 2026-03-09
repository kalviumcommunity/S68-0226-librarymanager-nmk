const Book = require("../models/Book");
const Copy = require("../models/Copy");

const getAllBooks = async (req, res) => {
  try {
    const { search, genre, available } = req.query;

    const query = {};

    if (search) {
      query.$or = [
        { title: { $regex: search, $options: "i" } },
        { authors: { $elemMatch: { $regex: search, $options: "i" } } },
        { isbn: { $regex: search, $options: "i" } },
      ];
    }

    if (genre) {
      query.genres = { $in: [genre] };
    }

    if (available === "true") {
      query.availableCopies = { $gt: 0 };
    }

    const books = await Book.find(query).sort({ createdAt: -1 });

    res.status(200).json({ count: books.length, books });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

const getBookById = async (req, res) => {
  try {
    const book = await Book.findById(req.params.id);

    if (!book) {
      return res.status(404).json({ message: "Book not found" });
    }

    const copies = await Copy.find({ bookId: book._id }).populate("branchId", "name address");
    res.status(200).json({ book, copies });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

const createBook = async (req, res) => {
  try {
    const { title, authors, isbn, summary, genres, coverUrl, publisher } = req.body;

    if (!title || !authors || !isbn) {
      return res.status(400).json({ message: "Title, authors and isbn are required" });
    }

    const existingBook = await Book.findOne({ isbn });
    if (existingBook) {
      return res.status(400).json({ message: "Book with this ISBN already exists" });
    }

    const book = await Book.create({
      title,
      authors,
      isbn,
      summary: summary || "",
      genres: genres || [],
      coverUrl: coverUrl || "",
      publisher: publisher || "",
      totalCopies: 0,
      availableCopies: 0,
    });

    res.status(201).json({ message: "Book created successfully", book });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

const updateBook = async (req, res) => {
  try {
    const updatedBook = await Book.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!updatedBook) {
      return res.status(404).json({ message: "Book not found" });
    }

    res.status(200).json({ message: "Book updated successfully", book: updatedBook });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

const deleteBook = async (req, res) => {
  try {
    const book = await Book.findById(req.params.id);

    if (!book) {
      return res.status(404).json({ message: "Book not found" });
    }

    await Copy.deleteMany({ bookId: book._id });
    await book.deleteOne();

    res.status(200).json({ message: "Book and related copies deleted successfully" });
  } catch (error) {
    res.status(500);
    throw error;
  }
};

module.exports = {
  getAllBooks,
  getBookById,
  createBook,
  updateBook,
  deleteBook,
};
