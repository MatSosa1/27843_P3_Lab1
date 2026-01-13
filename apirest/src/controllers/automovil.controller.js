const Automovil = require('../models/automovil');

exports.create = async (req, res) => {
  const auto = await Automovil.create(req.body);
  res.status(201).json(auto);
};

exports.findAll = async (req, res) => {
  const autos = await Automovil.find().populate('propietario');
  res.json(autos);
};
