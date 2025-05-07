import * as pacienteModel from '../models/pacienteModel.js';

export const getAllPacientes = async (req, res) => {
  try {
    const pacientes = await pacienteModel.getPacientes();
    res.json(pacientes);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const addPaciente = async (req, res) => {
  try {
    const { nombre, edad } = req.body;
    const result = await pacienteModel.createPaciente({ nombre, edad });
    res.status(201).json({ affectedRows: result });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};