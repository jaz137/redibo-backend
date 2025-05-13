const express = require('express');
const { prisma } = require('../lib/prisma');

const router = express.Router();

router.get('/:hostId', async (req, res) => {
    const { hostId } = req.params;
    
    try {
      
      const hostIdNum = parseInt(hostId, 10);
      
      if (isNaN(hostIdNum)) {
        return res.status(400).json({
          error: "ID de host inválido",
          details: "El ID debe ser un número"
        });
      }
      
      const cars = await prisma.carro.findMany({
        where: {
          id_usuario_rol: hostIdNum 
        },
        select: {
          id: true,
          vim: true,
          anio: true,
          marca: true,
          modelo: true,
          placa: true,
          asientos: true,
          puertas: true,
          soat: true,
          precio_por_dia: true,
          num_mantenimientos: true,
          transmision: true,
          estado: true,
          direccion: {
            select: {
              calle: true,
              num_casa: true,
              provincia: {
                select: {
                  nombre: true,
                  ciudad: {
                    select: {
                      nombre: true,
                      pais: {
                        select: {
                          nombre: true
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          combustiblesporCarro: { 
            select: { 
              combustible: { 
                select: { tipoDeCombustible: true } 
              } 
            } 
          },
          caracteristicasAdicionalesCarro: { 
            select: { 
              carasteristicasAdicionales: { 
                select: { nombre: true } 
              } 
            } 
          },
          imagenes: { select: { data: true, public_id: true } }
        }
      });
  
      if (!cars.length) {
        return res.status(404).json({ 
          message: "No se encontraron autos para este host",
          hostId
        });
      }
  
      const formattedCars = cars.map(car => {
        
        const caracteristicas = car.caracteristicasAdicionalesCarro.map(c => 
          c.carasteristicasAdicionales.nombre);
        
        
        const combustibles = car.combustiblesporCarro.map(c => 
          c.combustible.tipoDeCombustible);
        
       
        const imagenes = car.imagenes.map(img => ({
          url: img.data,
          public_id: img.public_id
        }));
        
        return {
          id: car.id,
          vim: car.vim,
          año: car.anio,
          marca: car.marca,
          modelo: car.modelo,
          placa: car.placa,
          asientos: car.asientos,
          puertas: car.puertas,
          soat: car.soat,
          precio_por_dia: car.precio_por_dia,
          num_mantenimientos: car.num_mantenimientos || 0,
          transmision: car.transmision || 'No especificado',
          estado: car.estado === 'DISPONIBLE' ? 'Disponible' : 
                 car.estado === 'RESERVADO' ? 'Reservado' : 'En mantenimiento',
          direccion: car.direccion?.calle,
          ciudad: car.direccion?.provincia?.ciudad?.nombre,
          provincia: car.direccion?.provincia?.nombre,
          pais: car.direccion?.provincia?.pais?.nombre,
          combustibles,
          caracteristicas,
          imagenes,
          tiene_placa: !!car.placa 
        };
      });
  
      res.json({
        total: cars.length,
        autos_con_placa: cars.filter(c => c.placa).length,
        autos: formattedCars
      });
    } catch (error) {
      console.error("Error:", error);
      res.status(500).json({ 
        error: "Error en el servidor",
        details: process.env.NODE_ENV === 'development' ? {
          message: error.message,
          stack: error.stack
        } : null
      });
    }
});

module.exports = router;