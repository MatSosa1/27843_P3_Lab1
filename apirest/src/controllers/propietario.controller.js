const Propietario = require('../models/propietario');

exports.create = async (req, res) => {
  const propietario = await Propietario.create(req.body);
  res.status(201).json(propietario);
};

exports.findAll = async (req, res) => {
  const propietarios = await Propietario.find();
  res.json(propietarios);
};
