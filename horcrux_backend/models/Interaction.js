const mongoose = require("mongoose");

const interactionSchema = new mongoose.Schema({
  uid: {
    type: String,
    required: true,
  },
  pid: {
    type: String,
    required: true,
  },
  interactionType: {
    type: String,
    required: true,
  },
  timestamp: {
    type: Date,
    required: true,
    default: Date.now,
  },
});

module.exports = mongoose.model("interactions", interactionSchema);
