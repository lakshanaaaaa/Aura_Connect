# CodeTrack

A comprehensive student performance tracking and coding analytics platform built with the MERN stack.

## Features

- **Student Performance Analytics** - Track and analyze student coding contest ratings and improvements
- **Department Management** - Monitor department-wide student performance metrics
- **Admin Dashboard** - Comprehensive user management and system overview
- **Contest Analytics** - Detailed insights into coding platform performance across LeetCode, CodeChef, and Codeforces
- **User Profiles** - Individual student profiles with problem-solving statistics and achievements

## Screenshots

### Department Analytics Dashboard
![Department Analytics](frontend/public/screenshot-for-readme.png)
Track student rating improvements and contest participation with detailed analytics for department performance overview.

### Admin Dashboard
![Admin Dashboard](frontend/public/screenshot-for-readme.png)
Manage users, roles, and monitor system-wide statistics with comprehensive admin controls.

### Student Profile & Analytics
![Student Profile](frontend/public/screenshot-for-readme.png)
View individual student coding profiles with platform-wise statistics, contest ratings, problem-solving analytics, and achievements.

## Tech Stack

### Backend
- Node.js & Express.js
- MongoDB with Mongoose
- JWT Authentication
- Cloudinary (media storage)
- Mailtrap (email services)

### Frontend
- React 18 with Vite
- TanStack Query (React Query)
- Tailwind CSS & DaisyUI
- React Router DOM
- Axios

## Installation

1. Clone the repository
```bash
git clone <repository-url>
cd codetrack
```

2. Install dependencies
```bash
npm install
cd frontend && npm install
```

3. Configure environment variables
Create a `.env` file in the root directory with required credentials

4. Run the application
```bash
# Development mode
npm run dev

# Production build
npm run build
npm start
```

## License

ISC
