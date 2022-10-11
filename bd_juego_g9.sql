CREATE DATABASE bd_juego_g9

USE bd_juego_g9


CREATE TABLE tiendas
(
  id_tienda INT IDENTITY NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  cant_slots INT NOT NULL,
  CONSTRAINT PK_tiendas PRIMARY KEY (id_tienda)
);

CREATE TABLE categorias
(
  id_categoria INT IDENTITY NOT NULL,
  titulo_categoria VARCHAR(100) NOT NULL,
  descripcion VARCHAR(100),
  CONSTRAINT PK_categorias PRIMARY KEY (id_categoria)
);

CREATE TABLE inventarios
(
  id_inventario INT IDENTITY NOT NULL,
  cant_slots INT NOT NULL,
  CONSTRAINT PK_inventarios PRIMARY KEY (id_inventario)
);

CREATE TABLE cuentas
(
  id_usuario int IDENTITY NOT NULL,
  nombre_usuario VARCHAR(100) NOT NULL,
  contra VARCHAR(100) NOT NULL,
  ip_usuario VARCHAR(100) NOT NULL,
  CONSTRAINT PK_cuentas PRIMARY KEY (id_usuario),
  CONSTRAINT UQ_nombre_usuario UNIQUE (nombre_usuario)
);

CREATE TABLE mapas
(
  id_mapa INT IDENTITY NOT NULL,
  nombre_mapa VARCHAR(100) NOT NULL,
  tamanio_x INT NOT NULL,
  tamanio_y INT NOT NULL,
  CONSTRAINT PK_mapas PRIMARY KEY (id_mapa)
);

CREATE TABLE npcs_tipos
(
  id_tipo INT NOT NULL,
  nombre_tipo VARCHAR(100) NOT NULL,
  CONSTRAINT PK_npcs_tipo PRIMARY KEY (id_tipo)
);

CREATE TABLE clases
(
  id_clase INT IDENTITY NOT NULL,
  nombre_clase VARCHAR(100),
  descripcion VARCHAR(100),
  CONSTRAINT PK_clases PRIMARY KEY (id_clase)
);

CREATE TABLE npcs
(
  id_npc INT IDENTITY NOT NULL,
  id_tipo INT NOT NULL,
  nombre_npc VARCHAR(100) NOT NULL,
  vida FLOAT NOT NULL,
  nivel INT NOT NULL,
  experiencia FLOAT NOT NULL,
  fuerza INT NOT NULL,
  agilidad INT NOT NULL,
  magia INT NOT NULL,
  estatico BIT NOT NULL,
  CONSTRAINT PK_npcs PRIMARY KEY (id_npc),
  CONSTRAINT FK_npcs_tipos FOREIGN KEY (id_tipo) REFERENCES npcs_tipos(id_tipo)
);

CREATE TABLE items
(
  id_item INT IDENTITY NOT NULL,
  id_categoria INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  fuerza INT NOT NULL,
  agilidad INT NOT NULL,
  magia INT NOT NULL,
  req_fuerza INT NOT NULL,
  req_agilidad INT NOT NULL,
  req_magia INT NOT NULL,
  req_clase INT NOT NULL,
  req_nivel INT NOT NULL,
  poder_defensa FLOAT NOT NULL,
  poder_ataque FLOAT NOT NULL,
  poder_magico FLOAT NOT NULL,
  descripcion VARCHAR(100),
  CONSTRAINT PK_items PRIMARY KEY (id_item),
  CONSTRAINT FK_items_categorias FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);