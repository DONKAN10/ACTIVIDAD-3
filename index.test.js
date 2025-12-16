// index.test.js

const { sum } = require('./index');

describe('Pruebas de la función SUMA', () => {
  test('Debe sumar dos números positivos correctamente', () => {
    expect(sum(1, 2)).toBe(3);
  });

  test('Debe manejar números negativos', () => {
    expect(sum(-1, 5)).toBe(4);
  });

  test('Debe sumar con cero', () => {
    expect(sum(10, 0)).toBe(10);
  });
});