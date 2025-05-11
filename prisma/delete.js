const { PrismaClient } = require("@prisma/client")
const prisma = new PrismaClient()

async function cleanOrphanUsers() {
  try {
    // Paso 1: Encontrar usuarios sin relaciones en otras tablas
    const usersToDelete = await prisma.usuario.findMany({
      where: {
        // Filtra usuarios que NO tienen registros en tablas relacionadas
        AND: [
          { favoritos: { none: {} } },
          { calificaciones: { none: {} } },
          { notificaciones: { none: {} } },
          { reservas: { none: {} } },
          { carros: { none: {} } },
          { busquedas: { none: {} } },
        ],
      },
      select: { id: true },
    })

    if (usersToDelete.length === 0) {
      console.log("⚠️ No hay usuarios huérfanos para eliminar")
      return
    }
    // Paso 2: Eliminar en transacción
    await prisma.$transaction(async (prisma) => {
      // Eliminar registros en PasswordRecoveryCode antes de borrar usuarios
      await prisma.passwordRecoveryCode.deleteMany({
        where: {
          id_usuario: { in: usersToDelete.map((user) => user.id) },
        },
      })

      // Eliminar UsuarioRol de estos usuarios
      await prisma.usuarioRol.deleteMany({
        where: {
          id_usuario: {
            in: usersToDelete.map((user) => user.id),
          },
        },
      })

      // Eliminar los usuarios
      await prisma.usuario.deleteMany({
        where: {
          id: {
            in: usersToDelete.map((user) => user.id),
          },
        },
      })
    })

    console.log(`✅ Eliminados ${usersToDelete.length} usuarios huérfanos`)
  } catch (error) {
    console.error("❌ Error:", error)
  } finally {
    await prisma.$disconnect()
  }
}

async function deleteOrphanUsersByEmails(emails) {
  try {
    if (!emails || emails.length === 0) {
      console.log("⚠️ Lista de correos vacía")
      return
    }

    // Paso 1: Buscar usuarios huérfanos que estén en la lista de correos
    const usersToDelete = await prisma.usuario.findMany({
      where: {
        AND: [
          { correo: { in: emails } }, // Solo los correos en la lista
          {
            AND: [
              // Que cumplan con ser huérfanos
              { favoritos: { none: {} } },
              { calificaciones: { none: {} } },
              { notificaciones: { none: {} } },
              { reservas: { none: {} } },
              { carros: { none: {} } },
              { busquedas: { none: {} } },
            ],
          },
        ],
      },
      select: { id: true, correo: true },
    })

    if (usersToDelete.length === 0) {
      console.log("⚠️ No hay usuarios huérfanos con esos correos")
      return
    }

    const userIds = usersToDelete.map((user) => user.id)
    const userEmails = usersToDelete.map((user) => user.correo)

    // Paso 2: Eliminar en transacción solo si son huérfanos
    await prisma.$transaction(async (prisma) => {
      // Eliminar códigos de recuperación
      await prisma.passwordRecoveryCode.deleteMany({
        where: { id_usuario: { in: userIds } },
      })

      // Eliminar roles de usuario
      await prisma.usuarioRol.deleteMany({
        where: { id_usuario: { in: userIds } },
      })

      // Eliminar usuarios
      await prisma.usuario.deleteMany({
        where: { id: { in: userIds } },
      })
    })

    console.log(`✅ Eliminados ${usersToDelete.length} usuarios huérfanos:`)
    console.log(userEmails.join(", "))
  } catch (error) {
    console.error("❌ Error:", error)
  } finally {
    await prisma.$disconnect()
  }
}
// Ejecutar
//cleanOrphanUsers();

// deleteUsersByEmails(['user1@example.com', 'user2@example.com']);
const emails = []
deleteOrphanUsersByEmails(emails)
