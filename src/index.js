const express = require("express")
const { PrismaClient } = require("@prisma/client")
const morgan = require("morgan")
const cors = require("cors")
const passport = require("./config/passport")
const dotenv = require("dotenv")
const cookieParser = require("cookie-parser")

// Cargar variables de entorno
dotenv.config()

// Importar rutas
const userRoutes = require("./routes/userRoutes")
const usuariosRoutes = require("./routes/usuariosRoutes")
const cityRoutes = require("./routes/cityRoutes")
const authRoutes = require("./routes/authRoutes")
const renterDetailsRoutes = require("./routes/renterDetailsRoutes")
const reservasRoutes = require("./routes/reservasRoutes")
const reporteRoutes = require("./routes/reporteRoutes")
const comentariosCarroRoutes = require("./routes/comentariosCarroRoutes")
const calificacionesReservaRoutes = require("./routes/calificaciones-reservaRoutes")

const app = express()
const prisma = new PrismaClient()

// Configuración de cookies
app.use(cookieParser(process.env.COOKIE_SECRET || "redibo-secret"))

// Configuración de CORS
app.use(
  cors({
    origin: process.env.FRONTEND_URL || "http://localhost:3000",
    credentials: true,
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization", "Cookie"],
    exposedHeaders: ["Set-Cookie", "Cookie", "Date", "ETag"],
  }),
)

// Middleware
app.use(express.json())
app.use(morgan("dev"))
app.use(passport.initialize())

// Ruta principal
app.get("/", (req, res) => {
  res.send("server is running")
})

// Rutas de la API
app.use("/api", userRoutes)
app.use("/api/usuarios", usuariosRoutes)
app.use("/api", cityRoutes)
app.use("/api/auth", authRoutes)
app.use("/api/renter-details", renterDetailsRoutes)
app.use("/api/reservas", reservasRoutes)
app.use("/api/reportes", reporteRoutes)
app.use("/api/comentarios-carro", comentariosCarroRoutes)
app.use("/api/calificaciones-reserva", calificacionesReservaRoutes)


// Manejo de errores
app.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).json({
    error: "Error interno del servidor",
    message: process.env.NODE_ENV === "development" ? err.message : undefined,
  })
})

// Puerto
const PORT = process.env.PORT || 4000

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`)
})
