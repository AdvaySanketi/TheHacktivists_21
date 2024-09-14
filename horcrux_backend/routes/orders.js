const express = require("express");
const User = require("../models/User");
const Product = require("../models/Product");
const Order = require("../models/Order");
const Interaction = require("../models/Interaction");
const authenticateToken = require("../middleware/authToken");
const router = express.Router();

// [1] Get Orders
router.get("/", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const orders = Order.find({
      uid: userId,
    });

    res.json({ data: orders });
  } catch (error) {
    res.status(500).json({ message: "Error fetching cart", error });
  }
});

// [2] Create Order
router.post("/create-order", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const { items, vendors, amount, order_status } = req.body;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: "Items are required" });
    }
    if (!vendors || !Array.isArray(vendors) || vendors.length === 0) {
      return res.status(400).json({ message: "Vendors are required" });
    }

    const productIds = items.map((item) => item.pid);
    const products = await Product.find({ pid: { $in: productIds } });

    if (products.length !== productIds.length) {
      return res
        .status(404)
        .json({ message: "One or more products not found" });
    }

    let calculatedAmount = 0;
    products.forEach((product) => {
      const quantity = items.find(
        (item) => item.pid === product.pid.toString()
      ).quantity;
      calculatedAmount += product.price * quantity;
    });

    const newOrder = new Order({
      oid: uuidv4(),
      uid: userId,
      items,
      vendors,
      amount: calculatedAmount,
    });

    await newOrder.save();

    const user = await User.findById(userId);
    user.cart = [];
    await user.save();

    res
      .status(201)
      .json({ message: "Order created successfully", order: newOrder });
  } catch (error) {
    console.error("Error creating order:", error);
    res.status(500).json({ message: "Error creating order", error });
  }
});

module.exports = router;
