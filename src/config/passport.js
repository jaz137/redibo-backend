const passport = require("passport")
const GoogleStrategy = require("passport-google-oauth20").Strategy
const { PrismaClient } = require("@prisma/client")
const prisma = new PrismaClient()

passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: process.env.GOOGLE_CALLBACK_URL,
      scope: ["profile", "email"],
    },
    async (accessToken, refreshToken, profile, done) => {
      try {
        const email = profile.emails[0].value

        // Buscar si el usuario ya existe por correo o google_id
        const existingUser = await prisma.usuario.findFirst({
          where: {
            OR: [{ correo: email }, { google_id: profile.id }],
          },
          include: {
            roles: {
              include: {
                rol: true,
              },
            },
          },
        })

        if (existingUser) {
          // Si el usuario existe pero no tiene google_id o foto, actualizar esos campos
          const updateData = {}
          if (!existingUser.google_id) {
            updateData.google_id = profile.id
          }
          if (!existingUser.foto || existingUser.foto.startsWith("https://ui-avatars.com/api/")) {
            updateData.foto = profile.photos && profile.photos.length > 0 ? profile.photos[0].value : null
          }
          if (Object.keys(updateData).length > 0) {
            await prisma.usuario.update({
              where: { id: existingUser.id },
              data: updateData,
            })
          }

          // Verificar si el perfil está incompleto según campos clave
          const camposRequeridos = [
            existingUser.fecha_nacimiento,
            existingUser.genero,
            existingUser.telefono,
            existingUser.id_ciudad,
          ]

          const perfilIncompleto =
            camposRequeridos.some((campo) => campo === null || campo === "" || campo === undefined) ||
            !existingUser.roles?.length

          // Verificar si el perfil está completo
          if (perfilIncompleto) {
            // El usuario existe pero su perfil está incompleto
            return done(null, {
              isNewUser: false,
              isIncomplete: true,
              id: existingUser.id,
              correo: existingUser.correo,
              nombre: existingUser.nombre,
              foto: existingUser.foto,
            })
          }
          const userComplete = await prisma.usuario.findFirst({
            where: {
              OR: [{ correo: email }, { google_id: profile.id }],
            },
            select: {
              id: true,
              nombre: true,
              correo: true,
              telefono: true,
              fecha_nacimiento: true,
              genero: true,
              foto: true,
              google_id: true,
              ciudad: {
                select: {
                  nombre: true,
                },
              },
              roles: {
                select: {
                  rol: {
                    select: {
                      rol: true,
                    },
                  },
                },
              },
            },
          })
          // Extraer roles para el token JWT
          const roles = userComplete.roles.map((userRole) => userRole.rol.rol)
          // Usuario ya existe y su perfil está completo
          return done(null, {
            isNewUser: false,
            isIncomplete: false,
            id: userComplete.id,
            nombre: userComplete.nombre,
            correo: userComplete.correo,
            telefono: userComplete.telefono,
            fecha_nacimiento: userComplete.fecha_nacimiento,
            genero: userComplete.genero,
            ciudad: userComplete.ciudad.nombre,
            foto: userComplete.foto,
            roles: roles,
          })
        }

        // Es un usuario nuevo, lo creamos con datos parciales
        const newUser = await prisma.usuario.create({
          data: {
            google_id: profile.id,
            correo: email.toLowerCase(),
            nombre: profile.displayName,
            foto: profile.photos && profile.photos.length > 0 ? profile.photos[0].value : null,
          },
        })

        // Retornamos el nuevo usuario con flag de incompleto
        return done(null, {
          isNewUser: true,
          isIncomplete: true,
          id: newUser.id,
          correo: newUser.correo,
          nombre: newUser.nombre,
          foto: newUser.foto,
        })
      } catch (error) {
        console.error("Error en estrategia Google:", error)
        return done(error)
      }
    },
  ),
)

module.exports = passport
