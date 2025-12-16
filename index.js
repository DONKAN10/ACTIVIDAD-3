// index.js

const express = require('express');
const app = express();
const port = 3000;

// Función simple que queremos probar (e.g., para CI)
const sum = (a, b) => a + b;

app.get('/', (req, res) => {
  res.send('¡Hola desde Actividad 3 con Express!');
});

app.get('/sumar/:a/:b', (req, res) => {
  const a = parseInt(req.params.a);
  const b = parseInt(req.params.b);
  if (isNaN(a) || isNaN(b)) {
    return res.status(400).send('Ambos parámetros deben ser números.');
  }
  const result = sum(a, b);
  res.send(`La suma de ${a} y ${b} es ${result}`);
});

// La aplicación escucha solo si no está en un entorno de prueba
if (process.env.NODE_ENV !== 'test') {
  app.listen(port, () => {
    console.log(`🚀 Servidor Express escuchando en http://localhost:${port}`);
  });
}

// Exportamos la función sum para poder probarla
module.exports = { app, sum };