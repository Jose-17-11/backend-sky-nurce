import express from 'express';
import pacienteRoutes from './routes/pacienteRoutes.js';
import { getConnection } from './config/db.js';

const app = express();

// Middlewares
app.use(express.json());

// Rutas
app.use('/api', pacienteRoutes);

// Test DB Connection
async function testConnection() {
  try {
    await getConnection();
    console.log('Database connected!');
  } catch (error) {
    console.error('Database connection failed:', error);
  }
}

testConnection();

export default app;