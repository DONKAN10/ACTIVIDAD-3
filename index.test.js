// index.test.js
describe('Pruebas para el Pipeline CI/CD', () => {
  test('Verificar que las pruebas unitarias se ejecuten exitosamente', () => {
    // Si esta prueba falla, el pipeline de GitHub Actions se detendrá.
    expect(2 + 2).toBe(4);
  });
  
  test('Verificar configuración de Jest', () => {
    expect({}).toEqual({});
  });
});