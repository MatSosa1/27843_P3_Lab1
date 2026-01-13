const mongoose = require('mongoose');

const PropietarioSchema = new mongoose.Schema({
  nombre: { type: String, required: true },
  apellido: { type: String, required: true },
  edad: { type: Number, required: true }
}, { timestamps: true });

module.exports = mongoose.model('Propietario', PropietarioSchema);
