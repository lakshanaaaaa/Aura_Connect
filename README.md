# Aura Connect - LinkedIn Clone

![CI Pipeline](https://github.com/lakshanaaaaa/Aura_Connect/actions/workflows/ci.yml/badge.svg)

A full-stack social networking application built with the MERN stack (MongoDB, Express, React, Node.js).

## Features

- 🔐 User authentication (signup/login)
- 👤 User profiles with education, experience, and skills
- 📝 Create, edit, and delete posts
- 💬 Like and comment on posts
- 🔔 Real-time notifications
- 🤝 Connection requests and networking
- 📅 Coding contest calendar
- 🖼️ Image upload with Cloudinary
- 📧 Email notifications with Mailtrap

## Tech Stack

### Frontend
- React 18
- React Router DOM
- TanStack Query (React Query)
- Axios
- Tailwind CSS
- DaisyUI
- Vite

### Backend
- Node.js
- Express
- MongoDB with Mongoose
- JWT Authentication
- Cloudinary (Image Upload)
- Mailtrap (Email Service)

## Project Structure

```
├── backend/
│   ├── controllers/     # Route controllers
│   ├── models/          # Database models
│   ├── routes/          # API routes
│   ├── middleware/      # Custom middleware
│   ├── lib/             # Utility functions
│   └── server.js        # Entry point
├── frontend/
│   ├── src/
│   │   ├── components/  # React components
│   │   ├── pages/       # Page components
│   │   ├── lib/         # Utilities
│   │   └── utils/       # Helper functions
│   └── public/          # Static assets
└── package.json         # Root package file
```

## Getting Started

### Prerequisites

- Node.js >= 18.0.0
- npm >= 9.0.0
- MongoDB (local or Atlas)

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd aura-connect
```

2. Install dependencies
```bash
npm install
npm run install:all
```

3. Set up environment variables

Create `.env` file in the root directory:

**.env**
```env
PORT=5000
NODE_ENV=development
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_API_KEY=your_cloudinary_api_key
CLOUDINARY_API_SECRET=your_cloudinary_api_secret
MAILTRAP_TOKEN=your_mailtrap_token
```

### Development

Run both frontend and backend in a single terminal:
```bash
npm run dev
```

This will start:
- Backend on http://localhost:5000
- Frontend on http://localhost:8080

### Production Build

```bash
npm run build
npm start
```

### Deployment

For platforms like Render:

**Build Command:**
```bash
npm run build
```

**Start Command:**
```bash
npm start
```

Make sure to set `NODE_ENV=production` in your environment variables.

## Available Scripts

- `npm run dev` - Run both frontend and backend in development mode (single terminal)
- `npm run build` - Install dependencies and build frontend for production
- `npm start` - Start backend server (serves frontend in production)
- `npm run install:all` - Install all dependencies
- `npm run clean` - Clean node_modules and build files

## API Endpoints

- `POST /api/v1/auth/signup` - User registration
- `POST /api/v1/auth/login` - User login
- `GET /api/v1/auth/me` - Get current user
- `GET /api/v1/users/:username` - Get user profile
- `POST /api/v1/posts` - Create post
- `GET /api/v1/posts` - Get all posts
- `POST /api/v1/connections/request/:userId` - Send connection request
- `GET /api/v1/notifications` - Get notifications
- `GET /api/v1/coding/contests` - Get coding contests

## License

ISC

## Author

Your Name
