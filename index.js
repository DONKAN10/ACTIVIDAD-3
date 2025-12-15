// index.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  // Usando una variable de entorno para demostrar el uso de secretos
  const secretMessage = process.env.WELCOME_MESSAGE || "Hola Mundo por defecto";
  res.send(`Servidor Corriendo! Mensaje: ${secretMessage}`);
});

app.listen(port, () => {
  console.log(`Ejemplo escuchando en http://localhost:${port}`);
});