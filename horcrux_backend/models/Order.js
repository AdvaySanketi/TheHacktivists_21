const mongoose = require("mongoose");

const orderSchema = new mongoose.Schema({
  oid: {
    type: String,
    required: true,
    unique: true,
  },
  uid: {
    type: String,
    required: true,
  },
  items: {
    type: Array,
    required: true,
  },
  vendors: {
    type: Array,
    required: true,
  },
  amount: {
    type: Number,
    required: true,
  },
  order_placed_at: {
    type: Date,
    required: true,
    default: Date.now,
  },
  order_status: {
    type: String,
    required: true,
    default: "1",
    // 0 - failed
    // 1 - success
  },
});

module.exports = mongoose.model("orders", orderSchema);
