const express = require('express');
const router = express.Router();
const { PrismaClient } = require('@prisma/client');
const { query } = require('express-validator');
const { authenticateToken } = require('../middlewares/authMiddleware');
const prisma = new PrismaClient();

// Obtener reservas completadas por host
router.get('/completadas', authenticateToken, [
  query('hostId').isInt().withMessage('El ID del host es requerido')
], async (req, res) => {
  try {
    const { hostId } = req.query;

    // Verificar si el usuario tiene permiso para ver estas reservas
    if (parseInt(hostId) !== req.user.id) {
      return res.status(403).json({ error: 'No tienes permiso para ver estas reservas' });
    }

    const reservas = await prisma.reserva.findMany({
      where: {
        carro: {
          usuario: {
            id: parseInt(hostId)
          }
        },
        estado: 'COMPLETADA'
      },
      include: {
        usuario: true,
        carro: {
          include: {
            imagenes: true
          }
        }
      },
      orderBy: {
        fecha_fin: 'desc'
      }
    });

    res.json(reservas);
  } catch (error) {
    console.error('Error al obtener reservas completadas:', error);
    res.status(500).json({ 
      error: 'Error al obtener reservas completadas',
      message: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
});

module.exports = router; 