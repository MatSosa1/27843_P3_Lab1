const mongoose = require('mongoose');

const AutomovilSchema = new mongoose.Schema({
  modelo: { type: String, required: true },
  valor: { type: Number, required: true },
  accidentes: { type: Number, default: 0 },

  propietario: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Propietario',
    required: true
  }
}, { timestamps: true });

module.exports = mongoose.model('Automovil', AutomovilSchema);
