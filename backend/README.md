# Library Manager Full Stack Project

This repository contains:

- `library_manager/` → Flutter frontend
- `backend/` → Node.js + Express + MongoDB backend

## Backend setup

```bash
cd backend
npm install
cp .env.example .env
npm run seed-admin
npm run dev
```

Default test users:

- admin@library.com / admin123
- staff@library.com / staff123
- patron@library.com / patron123

## Frontend setup

Update `lib/services/api_config.dart` if your backend is running on a different machine or port.

```bash
cd library_manager
flutter pub get
flutter run
```
