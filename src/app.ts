import express, { Application } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { config } from './config';
import { errorHandler, notFound } from './middleware/error.middleware';
import routes from './routes';

// Load environment variables
dotenv.config();

const app: Application = express();

// Middleware
app.use(cors({
  origin: config.cors.allowedOrigins,
  credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use(`/api/${config.app.apiVersion}`, routes);

// Error handling
app.use(notFound);
app.use(errorHandler);

export default app;
