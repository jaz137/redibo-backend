-- CreateEnum
CREATE TYPE "Genero" AS ENUM ('MASCULINO', 'FEMENINO', 'OTRO');

-- CreateEnum
CREATE TYPE "Roles" AS ENUM ('HOST', 'RENTER', 'DRIVER');

-- CreateEnum
CREATE TYPE "EstadoReserva" AS ENUM ('PENDIENTE', 'CONFIRMADA', 'EN_CURSO', 'COMPLETADA', 'CANCELADA');

-- CreateEnum
CREATE TYPE "EstadoCarro" AS ENUM ('DISPONIBLE', 'RESERVADO', 'MANTENIMIENTO');

-- CreateTable
CREATE TABLE "Usuario" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "correo" TEXT NOT NULL,
    "fecha_nacimiento" TIMESTAMP(3),
    "genero" "Genero",
    "id_ciudad" INTEGER,
    "contraseña" TEXT,
    "google_id" TEXT,
    "foto" TEXT,
    "telefono" TEXT,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_actualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Usuario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UsuarioRol" (
    "id" SERIAL NOT NULL,
    "id_rol" INTEGER NOT NULL,
    "id_usuario" INTEGER NOT NULL,

    CONSTRAINT "UsuarioRol_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Rol" (
    "id" SERIAL NOT NULL,
    "rol" TEXT NOT NULL,

    CONSTRAINT "Rol_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PasswordRecoveryCode" (
    "id" SERIAL NOT NULL,
    "id_usuario" INTEGER NOT NULL,
    "correo" TEXT NOT NULL,
    "codigo" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "PasswordRecoveryCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Favorito" (
    "id" SERIAL NOT NULL,
    "id_usuario_rol" INTEGER NOT NULL,
    "id_carro" INTEGER NOT NULL,
    "id_usuario" INTEGER,

    CONSTRAINT "Favorito_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notificacion" (
    "id" SERIAL NOT NULL,
    "id_usuario_rol" INTEGER NOT NULL,
    "mensaje" TEXT NOT NULL,
    "leida" BOOLEAN NOT NULL DEFAULT false,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notificacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Carro" (
    "id" SERIAL NOT NULL,
    "vim" TEXT NOT NULL,
    "anio" INTEGER NOT NULL,
    "marca" TEXT NOT NULL,
    "modelo" TEXT NOT NULL,
    "placa" TEXT NOT NULL,
    "id_direccion" INTEGER NOT NULL,
    "fecha_ingreso" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "asientos" INTEGER NOT NULL,
    "puertas" INTEGER NOT NULL,
    "soat" BOOLEAN NOT NULL,
    "precio_por_dia" DOUBLE PRECISION NOT NULL,
    "num_mantenimientos" INTEGER NOT NULL,
    "transmision" TEXT NOT NULL,
    "estado" "EstadoCarro" NOT NULL DEFAULT 'DISPONIBLE',
    "id_usuario_rol" INTEGER NOT NULL,
    "descripcion" TEXT,
    "ingresoTotal" DOUBLE PRECISION DEFAULT 0,
    "NumeroViajes" INTEGER DEFAULT 0,
    "color" TEXT,
    "id_tipodeDescuento" INTEGER,
    "disponible_desde" TIMESTAMP(3),
    "disponible_hasta" TIMESTAMP(3),

    CONSTRAINT "Carro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SeguroCarro" (
    "id" SERIAL NOT NULL,
    "fechaInicio" TIMESTAMP(3) NOT NULL,
    "fechaFin" TIMESTAMP(3) NOT NULL,
    "id_carro" INTEGER NOT NULL,
    "id_seguro" INTEGER NOT NULL,

    CONSTRAINT "SeguroCarro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Seguro" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "tipoSeguro" TEXT NOT NULL,
    "empresa" TEXT NOT NULL,

    CONSTRAINT "Seguro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CombustibleCarro" (
    "id" SERIAL NOT NULL,
    "id_carro" INTEGER NOT NULL,
    "id_combustible" INTEGER NOT NULL,

    CONSTRAINT "CombustibleCarro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TipoCombustible" (
    "id" SERIAL NOT NULL,
    "tipoDeCombustible" TEXT NOT NULL,
    "id_carro" INTEGER NOT NULL,

    CONSTRAINT "TipoCombustible_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "caracteristicasAdicionalesCarro" (
    "id" SERIAL NOT NULL,
    "id_carro" INTEGER NOT NULL,
    "id_carasteristicasAdicionales" INTEGER NOT NULL,

    CONSTRAINT "caracteristicasAdicionalesCarro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CarasteristicasAdicionales" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "CarasteristicasAdicionales_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Imagen" (
    "id" SERIAL NOT NULL,
    "data" TEXT,
    "public_id" TEXT,
    "width" INTEGER,
    "height" INTEGER,
    "format" TEXT,
    "id_carro" INTEGER NOT NULL,

    CONSTRAINT "Imagen_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Calificacion" (
    "id" SERIAL NOT NULL,
    "id_usuario_rol" INTEGER NOT NULL,
    "calf_carro" INTEGER,
    "calf_usuario" INTEGER,
    "comentario" TEXT,
    "id_carro" INTEGER NOT NULL,
    "id_usuario" INTEGER NOT NULL,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Calificacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reserva" (
    "id" SERIAL NOT NULL,
    "id_carro" INTEGER NOT NULL,
    "id_usuario" INTEGER NOT NULL,
    "kilometraje" INTEGER,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_inicio" TIMESTAMP(3) NOT NULL,
    "montoPagoInicial" DOUBLE PRECISION,
    "montoTotalConDescuento" DOUBLE PRECISION,
    "hora_inicio" INTEGER,
    "hora_fin" INTEGER,
    "fecha_fin" TIMESTAMP(3),
    "fecha_expiracion" TIMESTAMP(3),
    "estado" "EstadoReserva" NOT NULL DEFAULT 'PENDIENTE',

    CONSTRAINT "Reserva_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CalificacionReserva" (
    "id" SERIAL NOT NULL,
    "id_reserva" INTEGER NOT NULL,
    "comportamiento" INTEGER NOT NULL,
    "cuidado_vehiculo" INTEGER NOT NULL,
    "puntualidad" INTEGER NOT NULL,
    "comentario" TEXT,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CalificacionReserva_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Descuento" (
    "id" SERIAL NOT NULL,
    "montoDescontado" DOUBLE PRECISION,
    "id_descuentoTipo" INTEGER,

    CONSTRAINT "Descuento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tipodeDescuento" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "porcentaje" DOUBLE PRECISION NOT NULL,
    "fecha_inicio" TIMESTAMP(3),
    "fecha_fin" TIMESTAMP(3),

    CONSTRAINT "tipodeDescuento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Garantia" (
    "id" SERIAL NOT NULL,
    "precio" DOUBLE PRECISION NOT NULL,
    "fecha_limite" TIMESTAMP(3) NOT NULL,
    "descripcion" TEXT,
    "pagado" BOOLEAN NOT NULL,
    "pagoPorDanos" BOOLEAN,
    "id_reserva" INTEGER,

    CONSTRAINT "Garantia_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contratodeAlquiler" (
    "id" SERIAL NOT NULL,
    "id_reserva" INTEGER NOT NULL,
    "kilometraje" INTEGER NOT NULL,
    "id_carro" INTEGER NOT NULL,
    "estado" TEXT NOT NULL DEFAULT 'pendiente',

    CONSTRAINT "contratodeAlquiler_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ciudad" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "id_pais" INTEGER,

    CONSTRAINT "Ciudad_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "aeropuerto" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "latitud" DOUBLE PRECISION,
    "longitud" DOUBLE PRECISION,
    "id_ciudad" INTEGER NOT NULL,

    CONSTRAINT "aeropuerto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pais" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "Pais_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Direccion" (
    "id" SERIAL NOT NULL,
    "id_provincia" INTEGER NOT NULL,
    "calle" TEXT NOT NULL,
    "zona" TEXT,
    "num_casa" TEXT,
    "latitud" DOUBLE PRECISION,
    "longitud" DOUBLE PRECISION,

    CONSTRAINT "Direccion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ubicacion" (
    "id" SERIAL NOT NULL,
    "id_direccion" INTEGER NOT NULL,
    "coordenadas" JSONB NOT NULL,
    "radio_cobertura" INTEGER NOT NULL DEFAULT 5000,

    CONSTRAINT "Ubicacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Provincia" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "id_ciudad" INTEGER NOT NULL,

    CONSTRAINT "Provincia_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Busqueda" (
    "id" SERIAL NOT NULL,
    "criterio" TEXT NOT NULL,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_usuario" INTEGER NOT NULL,

    CONSTRAINT "Busqueda_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ComentarioCarro" (
    "id" SERIAL NOT NULL,
    "id_carro" INTEGER NOT NULL,
    "id_usuario" INTEGER NOT NULL,
    "comentario" TEXT NOT NULL,
    "calificacion" INTEGER NOT NULL DEFAULT 0,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_actualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ComentarioCarro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reporte" (
    "id" SERIAL NOT NULL,
    "id_reportado" INTEGER NOT NULL,
    "id_reportador" INTEGER NOT NULL,
    "motivo" TEXT NOT NULL,
    "informacion_adicional" TEXT,
    "estado" TEXT NOT NULL DEFAULT 'PENDIENTE',
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_actualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Reporte_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_DescuentoToReserva" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_DescuentoToReserva_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "Usuario_correo_key" ON "Usuario"("correo");

-- CreateIndex
CREATE UNIQUE INDEX "Usuario_google_id_key" ON "Usuario"("google_id");

-- CreateIndex
CREATE INDEX "Usuario_correo_idx" ON "Usuario"("correo");

-- CreateIndex
CREATE INDEX "Usuario_google_id_idx" ON "Usuario"("google_id");

-- CreateIndex
CREATE INDEX "Usuario_id_ciudad_idx" ON "Usuario"("id_ciudad");

-- CreateIndex
CREATE INDEX "UsuarioRol_id_usuario_idx" ON "UsuarioRol"("id_usuario");

-- CreateIndex
CREATE INDEX "UsuarioRol_id_rol_idx" ON "UsuarioRol"("id_rol");

-- CreateIndex
CREATE UNIQUE INDEX "Rol_rol_key" ON "Rol"("rol");

-- CreateIndex
CREATE INDEX "PasswordRecoveryCode_id_usuario_idx" ON "PasswordRecoveryCode"("id_usuario");

-- CreateIndex
CREATE INDEX "PasswordRecoveryCode_codigo_idx" ON "PasswordRecoveryCode"("codigo");

-- CreateIndex
CREATE INDEX "Favorito_id_usuario_rol_idx" ON "Favorito"("id_usuario_rol");

-- CreateIndex
CREATE INDEX "Favorito_id_carro_idx" ON "Favorito"("id_carro");

-- CreateIndex
CREATE INDEX "Favorito_id_usuario_idx" ON "Favorito"("id_usuario");

-- CreateIndex
CREATE UNIQUE INDEX "Favorito_id_usuario_rol_id_carro_key" ON "Favorito"("id_usuario_rol", "id_carro");

-- CreateIndex
CREATE INDEX "Notificacion_id_usuario_rol_idx" ON "Notificacion"("id_usuario_rol");

-- CreateIndex
CREATE UNIQUE INDEX "Carro_placa_key" ON "Carro"("placa");

-- CreateIndex
CREATE INDEX "Carro_marca_modelo_idx" ON "Carro"("marca", "modelo");

-- CreateIndex
CREATE INDEX "Carro_id_direccion_idx" ON "Carro"("id_direccion");

-- CreateIndex
CREATE INDEX "Carro_id_usuario_rol_idx" ON "Carro"("id_usuario_rol");

-- CreateIndex
CREATE INDEX "Carro_id_tipodeDescuento_idx" ON "Carro"("id_tipodeDescuento");

-- CreateIndex
CREATE INDEX "Carro_estado_idx" ON "Carro"("estado");

-- CreateIndex
CREATE INDEX "SeguroCarro_id_carro_idx" ON "SeguroCarro"("id_carro");

-- CreateIndex
CREATE INDEX "SeguroCarro_id_seguro_idx" ON "SeguroCarro"("id_seguro");

-- CreateIndex
CREATE INDEX "CombustibleCarro_id_carro_idx" ON "CombustibleCarro"("id_carro");

-- CreateIndex
CREATE INDEX "CombustibleCarro_id_combustible_idx" ON "CombustibleCarro"("id_combustible");

-- CreateIndex
CREATE INDEX "caracteristicasAdicionalesCarro_id_carro_idx" ON "caracteristicasAdicionalesCarro"("id_carro");

-- CreateIndex
CREATE INDEX "caracteristicasAdicionalesCarro_id_carasteristicasAdicional_idx" ON "caracteristicasAdicionalesCarro"("id_carasteristicasAdicionales");

-- CreateIndex
CREATE INDEX "Imagen_id_carro_idx" ON "Imagen"("id_carro");

-- CreateIndex
CREATE INDEX "Calificacion_id_carro_idx" ON "Calificacion"("id_carro");

-- CreateIndex
CREATE INDEX "Calificacion_id_usuario_idx" ON "Calificacion"("id_usuario");

-- CreateIndex
CREATE INDEX "Reserva_id_carro_idx" ON "Reserva"("id_carro");

-- CreateIndex
CREATE INDEX "Reserva_id_usuario_idx" ON "Reserva"("id_usuario");

-- CreateIndex
CREATE INDEX "Reserva_fecha_inicio_fecha_fin_idx" ON "Reserva"("fecha_inicio", "fecha_fin");

-- CreateIndex
CREATE INDEX "Reserva_estado_idx" ON "Reserva"("estado");

-- CreateIndex
CREATE INDEX "CalificacionReserva_id_reserva_idx" ON "CalificacionReserva"("id_reserva");

-- CreateIndex
CREATE INDEX "Descuento_id_descuentoTipo_idx" ON "Descuento"("id_descuentoTipo");

-- CreateIndex
CREATE INDEX "Garantia_id_reserva_idx" ON "Garantia"("id_reserva");

-- CreateIndex
CREATE INDEX "contratodeAlquiler_id_carro_idx" ON "contratodeAlquiler"("id_carro");

-- CreateIndex
CREATE INDEX "Ciudad_id_pais_idx" ON "Ciudad"("id_pais");

-- CreateIndex
CREATE INDEX "aeropuerto_id_ciudad_idx" ON "aeropuerto"("id_ciudad");

-- CreateIndex
CREATE INDEX "Direccion_id_provincia_idx" ON "Direccion"("id_provincia");

-- CreateIndex
CREATE INDEX "Ubicacion_id_direccion_idx" ON "Ubicacion"("id_direccion");

-- CreateIndex
CREATE INDEX "Provincia_id_ciudad_idx" ON "Provincia"("id_ciudad");

-- CreateIndex
CREATE INDEX "Busqueda_id_usuario_idx" ON "Busqueda"("id_usuario");

-- CreateIndex
CREATE INDEX "ComentarioCarro_id_carro_idx" ON "ComentarioCarro"("id_carro");

-- CreateIndex
CREATE INDEX "ComentarioCarro_id_usuario_idx" ON "ComentarioCarro"("id_usuario");

-- CreateIndex
CREATE INDEX "Reporte_id_reportado_idx" ON "Reporte"("id_reportado");

-- CreateIndex
CREATE INDEX "Reporte_id_reportador_idx" ON "Reporte"("id_reportador");

-- CreateIndex
CREATE INDEX "_DescuentoToReserva_B_index" ON "_DescuentoToReserva"("B");

-- AddForeignKey
ALTER TABLE "Usuario" ADD CONSTRAINT "Usuario_id_ciudad_fkey" FOREIGN KEY ("id_ciudad") REFERENCES "Ciudad"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsuarioRol" ADD CONSTRAINT "UsuarioRol_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "Usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsuarioRol" ADD CONSTRAINT "UsuarioRol_id_rol_fkey" FOREIGN KEY ("id_rol") REFERENCES "Rol"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PasswordRecoveryCode" ADD CONSTRAINT "PasswordRecoveryCode_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "Usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Favorito" ADD CONSTRAINT "Favorito_id_usuario_rol_fkey" FOREIGN KEY ("id_usuario_rol") REFERENCES "UsuarioRol"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Favorito" ADD CONSTRAINT "Favorito_id_carro_fkey" FOREIGN KEY ("id_carro") REFERENCES "Carro"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Favorito" ADD CONSTRAINT "Favorito_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "Usuario"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notificacion" ADD CONSTRAINT "Notificacion_id_usuario_rol_fkey" FOREIGN KEY ("id_usuario_rol") REFERENCES "Usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Carro" ADD CONSTRAINT "Carro_id_direccion_fkey" FOREIGN KEY ("id_direccion") REFERENCES "Direccion"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Carro" ADD CONSTRAINT "Carro_id_usuario_rol_fkey" FOREIGN KEY ("id_usuario_rol") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Carro" ADD CONSTRAINT "Carro_id_tipodeDescuento_fkey" FOREIGN KEY ("id_tipodeDescuento") REFERENCES "tipodeDescuento"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SeguroCarro" ADD CONSTRAINT "SeguroCarro_id_carro_fkey" FOREIGN KEY ("id_carro") REFERENCES "Carro"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SeguroCarro" ADD CONSTRAINT "SeguroCarro_id_seguro_fkey" FOREIGN KEY ("id_seguro") REFERENCES "Seguro"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CombustibleCarro" ADD CONSTRAINT "CombustibleCarro_id_carro_fkey" FOREIGN KEY ("id_carro") REFERENCES "Carro"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CombustibleCarro" ADD CONSTRAINT "CombustibleCarro_id_combustible_fkey" FOREIGN KEY ("id_combustible") REFERENCES "TipoCombustible"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "caracteristicasAdicionalesCarro" ADD CONSTRAINT "caracteristicasAdicionalesCarro_id_carro_fkey" FOREIGN KEY ("id_carro") REFERENCES "Carro"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "caracteristicasAdicionalesCarro" ADD CONSTRAINT "caracteristicasAdicionalesCarro_id_carasteristicasAdiciona_fkey" FOREIGN KEY ("id_carasteristicasAdicionales") REFERENCES "CarasteristicasAdicionales"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Imagen" ADD CONSTRAINT "Imagen_id_carro_fkey" FOREIGN KEY ("id_carro") REFERENCES "Carro"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Calificacion" ADD CONSTRAINT "Calificacion_id_carro_fkey" FOREIGN KEY ("id_carro") REFERENCES "Carro"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Calificacion" ADD CONSTRAINT "Calificacion_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "Usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reserva" ADD CONSTRAINT "Reserva_id_carro_fkey" FOREIGN KEY ("id_carro") REFERENCES "Carro"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reserva" ADD CONSTRAINT "Reserva_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "Usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalificacionReserva" ADD CONSTRAINT "CalificacionReserva_id_reserva_fkey" FOREIGN KEY ("id_reserva") REFERENCES "Reserva"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Descuento" ADD CONSTRAINT "Descuento_id_descuentoTipo_fkey" FOREIGN KEY ("id_descuentoTipo") REFERENCES "tipodeDescuento"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Garantia" ADD CONSTRAINT "Garantia_id_reserva_fkey" FOREIGN KEY ("id_reserva") REFERENCES "Reserva"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contratodeAlquiler" ADD CONSTRAINT "contratodeAlquiler_id_carro_fkey" FOREIGN KEY ("id_carro") REFERENCES "Carro"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ciudad" ADD CONSTRAINT "Ciudad_id_pais_fkey" FOREIGN KEY ("id_pais") REFERENCES "Pais"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "aeropuerto" ADD CONSTRAINT "aeropuerto_id_ciudad_fkey" FOREIGN KEY ("id_ciudad") REFERENCES "Ciudad"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Direccion" ADD CONSTRAINT "Direccion_id_provincia_fkey" FOREIGN KEY ("id_provincia") REFERENCES "Provincia"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ubicacion" ADD CONSTRAINT "Ubicacion_id_direccion_fkey" FOREIGN KEY ("id_direccion") REFERENCES "Direccion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Provincia" ADD CONSTRAINT "Provincia_id_ciudad_fkey" FOREIGN KEY ("id_ciudad") REFERENCES "Ciudad"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Busqueda" ADD CONSTRAINT "Busqueda_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "Usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ComentarioCarro" ADD CONSTRAINT "ComentarioCarro_id_carro_fkey" FOREIGN KEY ("id_carro") REFERENCES "Carro"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ComentarioCarro" ADD CONSTRAINT "ComentarioCarro_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "Usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reporte" ADD CONSTRAINT "Reporte_id_reportado_fkey" FOREIGN KEY ("id_reportado") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reporte" ADD CONSTRAINT "Reporte_id_reportador_fkey" FOREIGN KEY ("id_reportador") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_DescuentoToReserva" ADD CONSTRAINT "_DescuentoToReserva_A_fkey" FOREIGN KEY ("A") REFERENCES "Descuento"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_DescuentoToReserva" ADD CONSTRAINT "_DescuentoToReserva_B_fkey" FOREIGN KEY ("B") REFERENCES "Reserva"("id") ON DELETE CASCADE ON UPDATE CASCADE;
