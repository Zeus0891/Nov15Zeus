# Nov15Zeus - ERP Enterprise Multitenant Platform

An enterprise-grade ERP platform built with modern technologies, designed for multi-tenant architecture.

## Technology Stack

- **Backend Framework:** Node.js with Express
- **Language:** TypeScript
- **Database:** PostgreSQL (hosted on Neon)
- **ORM:** Prisma
- **Architecture:** Multitenant

## Project Structure

```
Nov15Zeus/
├── src/
│   ├── config/          # Configuration files
│   ├── controllers/     # Request handlers
│   ├── middleware/      # Express middleware
│   ├── routes/          # API routes
│   ├── services/        # Business logic
│   ├── types/           # TypeScript type definitions
│   ├── utils/           # Utility functions
│   ├── app.ts           # Express app setup
│   └── server.ts        # Server entry point
├── prisma/
│   └── schema.prisma    # Database schema
├── .env                 # Environment variables (not in git)
├── .env.example         # Environment variables template
├── tsconfig.json        # TypeScript configuration
└── package.json         # Project dependencies
```

## Getting Started

### Prerequisites

- Node.js (v18 or higher)
- npm or yarn
- A Neon PostgreSQL database

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Zeus0891/Nov15Zeus.git
cd Nov15Zeus
```

2. Install dependencies:
```bash
npm install
```

3. Set up environment variables:
```bash
cp .env.example .env
```

4. Update the `.env` file with your Neon PostgreSQL connection strings:
   - Get your connection string from [Neon Console](https://console.neon.tech)
   - Update `DATABASE_URL` and `DIRECT_URL`

### Database Setup

1. Generate Prisma Client:
```bash
npm run prisma:generate
```

2. Run database migrations:
```bash
npm run prisma:migrate
```

3. (Optional) Open Prisma Studio to view your database:
```bash
npm run prisma:studio
```

### Running the Application

**Development mode:**
```bash
npm run dev
```

**Production build:**
```bash
npm run build
npm start
```

The server will start on `http://localhost:3000`

## API Endpoints

- **Health Check:** `GET /api/v1/health`

## Multitenant Architecture

This platform supports multitenancy through:
- Tenant isolation at the database level
- Tenant identification via subdomain or HTTP headers (`x-tenant-id`)
- Tenant-specific data scoping

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_ENV` | Application environment | `development` |
| `PORT` | Server port | `3000` |
| `DATABASE_URL` | Neon PostgreSQL connection string | `postgresql://...` |
| `DIRECT_URL` | Direct database connection (for migrations) | `postgresql://...` |
| `JWT_SECRET` | Secret key for JWT tokens | `your-secret-key` |
| `ALLOWED_ORIGINS` | CORS allowed origins | `http://localhost:3000` |

## Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build for production
- `npm start` - Start production server
- `npm run prisma:generate` - Generate Prisma Client
- `npm run prisma:migrate` - Run database migrations
- `npm run prisma:studio` - Open Prisma Studio

## License

ISC

