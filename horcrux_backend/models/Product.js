const mongoose = require("mongoose");

const productSchema = new mongoose.Schema({
  pid: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  price: { type: Number, required: true },
  desc: { type: String, required: true },
  vendor: { type: String, required: true },
  quantity: { type: Number, required: true },
  preview: { type: String, required: true },
});

// Create model from schema
module.exports = mongoose.model("products", productSchema);
