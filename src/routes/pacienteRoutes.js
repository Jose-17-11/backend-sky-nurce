import { Router } from 'express';
import { getAllPacientes, addPaciente } from '../controllers/pacienteController.js';

const router = Router();

router.get('/pacientes', getAllPacientes);
router.post('/pacientes', addPaciente);

export default router;