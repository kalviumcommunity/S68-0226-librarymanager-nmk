const dotenv = require("dotenv");
const bcrypt = require("bcryptjs");
const connectDB = require("./config/db");
const User = require("./models/User");

dotenv.config();

const seedAdmin = async () => {
  try {
    await connectDB();

    const defaultUsers = [
      {
        name: "Library Admin",
        email: "admin@library.com",
        password: "admin123",
        role: "admin",
        libraryCardId: "ADMIN-001",
      },
      {
        name: "Library Staff",
        email: "staff@library.com",
        password: "staff123",
        role: "staff",
        libraryCardId: "STAFF-001",
      },
      {
        name: "Patron User",
        email: "patron@library.com",
        password: "patron123",
        role: "patron",
        libraryCardId: "PAT-001",
      },
    ];

    for (const entry of defaultUsers) {
      const existing = await User.findOne({ email: entry.email });
      if (!existing) {
        const hashedPassword = await bcrypt.hash(entry.password, 10);
        await User.create({
          name: entry.name,
          email: entry.email,
          password: hashedPassword,
          role: entry.role,
          libraryCardId: entry.libraryCardId,
        });
      }
    }

    console.log("Default users seeded successfully");
    process.exit(0);
  } catch (error) {
    console.error("Seeding failed:", error.message);
    process.exit(1);
  }
};

seedAdmin();
