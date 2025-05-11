const { PrismaClient } = require("@prisma/client")

const prisma = new PrismaClient()

async function main() {
  // Insertar o actualizar Bolivia
  const paisNombre = "Bolivia"
  let bolivia = await prisma.pais.findFirst({ where: { nombre: paisNombre } })

  if (bolivia) {
    bolivia = await prisma.pais.update({
      where: { id: bolivia.id },
      data: { nombre: paisNombre },
    })
  } else {
    bolivia = await prisma.pais.create({
      data: { nombre: paisNombre },
    })
  }

  // Insertar o actualizar ciudades
  const ciudades = ["Beni", "Chuquisaca", "Cochabamba", "La Paz", "Oruro", "Pando", "Potosí", "Santa Cruz", "Tarija"]
  for (const nombre of ciudades) {
    const ciudadExistente = await prisma.ciudad.findFirst({
      where: { nombre },
    })

    if (ciudadExistente) {
      await prisma.ciudad.update({
        where: { id: ciudadExistente.id },
        data: {
          nombre,
          id_pais: bolivia.id,
        },
      })
    } else {
      await prisma.ciudad.create({
        data: {
          nombre,
          id_pais: bolivia.id,
        },
      })
    }
  }

  // Insertar o actualizar roles
  const roles = ["HOST", "RENTER", "DRIVER"]

  for (const rol of roles) {
    const rolExistente = await prisma.rol.findFirst({
      where: { rol },
    })

    if (rolExistente) {
      await prisma.rol.update({
        where: { id: rolExistente.id },
        data: { rol },
      })
    } else {
      await prisma.rol.create({
        data: { rol },
      })
    }
  }

  console.log("Seed ejecutado correctamente")
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
