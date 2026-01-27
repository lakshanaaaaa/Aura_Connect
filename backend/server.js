import express from "express";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";
import cors from "cors";
import path from "path";
import { fileURLToPath } from "url";

import authRoutes from "./routes/auth.route.js";
import userRoutes from "./routes/user.route.js";
import postRoutes from "./routes/post.route.js";
import notificationRoutes from "./routes/notification.route.js";
import connectionRoutes from "./routes/connection.route.js";
import codingRoutes from "./routes/coding.route.js";

import { connectDB } from "./lib/db.js";

// Get the directory name of the current module
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables from root directory
dotenv.config({ path: path.join(__dirname, "..", ".env") });

const app = express();
const PORT = process.env.PORT || 5000;

// CORS Configuration
if (process.env.NODE_ENV !== "production") {
	app.use(
		cors({
			origin: ["http://localhost:8080", "http://localhost:5173", "http://localhost:5174", "http://localhost:5175"],
			credentials: true,
		})
	);
} else {
	app.use(
		cors({
			origin: process.env.CLIENT_URL || ["https://aura-connectt.onrender.com"],
			credentials: true,
		})
	);
}

// Middleware
app.use(express.json({ limit: "5mb" }));
app.use(cookieParser());

// API Routes
app.use("/api/v1/auth", authRoutes);
app.use("/api/v1/users", userRoutes);
app.use("/api/v1/posts", postRoutes);
app.use("/api/v1/notifications", notificationRoutes);
app.use("/api/v1/connections", connectionRoutes);
app.use("/api/v1/coding", codingRoutes);

// Serve frontend in production
if (process.env.NODE_ENV === "production") {
	const frontendDistPath = path.join(__dirname, "..", "frontend", "dist");
	app.use(express.static(frontendDistPath));

	app.get("*", (req, res) => {
		res.sendFile(path.join(frontendDistPath, "index.html"));
	});
} else {
	// Root route - API health check (development only)
	app.get("/", (req, res) => {
		res.json({
			message: "🚀 Aura Connect Backend is running",
			status: "active",
			environment: process.env.NODE_ENV,
			endpoints: {
				auth: "/api/v1/auth",
				users: "/api/v1/users",
				posts: "/api/v1/posts",
				notifications: "/api/v1/notifications",
				connections: "/api/v1/connections",
				coding: "/api/v1/coding"
			}
		});
	});
}

// Start server
const startServer = async () => {
	try {
		await connectDB();
		console.log("✅ Database connected successfully");
		app.listen(PORT, () => {
			console.log(`🚀 Server is running on port ${PORT}`);
			console.log(`📍 Environment: ${process.env.NODE_ENV}`);
			if (process.env.NODE_ENV === "production") {
				console.log(`📦 Serving frontend from: ${path.join(__dirname, "..", "frontend", "dist")}`);
			}
		});
	} catch (error) {
		console.error("❌ Failed to start the server:", error.message);
		process.exit(1);
	}
};

startServer();
