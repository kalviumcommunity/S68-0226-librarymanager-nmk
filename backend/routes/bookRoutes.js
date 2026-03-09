const express = require("express");
const {
  getAllBooks,
  getBookById,
  createBook,
  updateBook,
  deleteBook,
} = require("../controllers/bookController");
const { protect } = require("../middleware/authMiddleware");
const allowRoles = require("../middleware/roleMiddleware");

const router = express.Router();

router.get("/", getAllBooks);
router.get("/:id", getBookById);

router.post("/", protect, allowRoles("admin", "staff"), createBook);
router.put("/:id", protect, allowRoles("admin", "staff"), updateBook);
router.delete("/:id", protect, allowRoles("admin"), deleteBook);

module.exports = router;
