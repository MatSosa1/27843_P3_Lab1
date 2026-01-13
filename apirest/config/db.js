const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/bdd_dto');

module.exports = mongoose;
