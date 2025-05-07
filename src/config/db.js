import sql from 'mssql';

const dbSettings = {
  user: 'SA',
  password: 'P@sswOrd123',
  server: 'mssql_server',
  database: 'SkyNurce',
  options: {
    encrypt: false, // Para desarrollo local
    trustServerCertificate: true // Para certificados autofirmados
  }
};

export async function getConnection() {
  try {
    const pool = await sql.connect(dbSettings);
    return pool;
  } catch (error) {
    console.error('Database connection error:', error);
    throw error;
  }
}

export { sql };