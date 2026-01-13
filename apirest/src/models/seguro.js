const mongoose = require('mongoose');

const SeguroSchema = new mongoose.Schema({
  costoTotal: { type: Number, required: true },

  automovil: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Automovil',
    required: true,
    unique: true // 1 a 1
  }
}, { timestamps: true });

module.exports = mongoose.model('Seguro', SeguroSchema);
