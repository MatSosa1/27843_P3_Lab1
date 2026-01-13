const Seguro = require('../models/seguro');

exports.create = async (req, res) => {
  const seguro = await Seguro.create(req.body);
  res.status(201).json(seguro);
};

exports.findAll = async (req, res) => {
  const seguros = await Seguro.find().populate({
    path: 'automovil',
    populate: { path: 'propietario' }
  });
  res.json(seguros);
};
