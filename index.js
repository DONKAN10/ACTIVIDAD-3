// index.js

const express = require('express');
const app = express();
const port = 3000;

// Función simple que queremos probar
const sum = (a, b) => a + b;

app.get('/', (req, res) => {
  res.send('¡Hola desde Actividad 3 con Express!');
});

// La aplicación escucha solo si no está en un entorno de prueba
if (process.env.NODE_ENV !== 'test') {
  app.listen(port, () => {
    console.log(`🚀 Servidor Express escuchando en http://localhost:${port}`);
  });
}

// Exportamos la app y la función sum
module.exports = { app, sum };