const express = require('express');
require('./config/db');

const app = express();
app.use(express.json());

app.use('/api/propietarios', require('./src/routes/propietario.routes'));
app.use('/api/automoviles', require('./src/routes/automovil.routes'));
app.use('/api/seguros', require('./src/routes/seguro.routes'));

app.listen(3000, () => {
  console.log('API ejecutándose en http://localhost:3000');
});
