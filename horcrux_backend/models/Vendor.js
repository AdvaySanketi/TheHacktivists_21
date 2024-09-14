const mongoose = require("mongoose");
const { Schema } = mongoose;
const Product = require("./Product");

const VendorSchema = new Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  isVerified: {
    type: String,
    enum: ["0", "1"],
    default: "0",
  },
  products: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Product",
    },
  ],
});

module.exports = mongoose.model("vendors", VendorSchema);
