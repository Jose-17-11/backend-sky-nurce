import { getConnection, sql } from '../config/db.js';

export const getPacientes = async () => {
  const pool = await getConnection();
  const result = await pool.request().query('SELECT * FROM Pacientes');
  return result.recordset;
};

export const createPaciente = async (pacienteData) => {
  const pool = await getConnection();
  const result = await pool.request()
    .input('nombre', sql.VarChar, pacienteData.nombre)
    .input('edad', sql.Int, pacienteData.edad)
    .query('INSERT INTO Pacientes (nombre_mascota, edad) VALUES (@nombre, @edad)');
  return result.rowsAffected;
};