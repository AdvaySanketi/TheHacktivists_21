const express = require("express");
const User = require("../models/User");
const Product = require("../models/Product");
const Order = require("../models/Order");
const Interaction = require("../models/Interaction");
const authenticateToken = require("../middleware/authToken");
const router = express.Router();

// [1] Get Cart
router.get("/cart", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const cart = await Product.find({ pid: { $in: user.cart } });

    res.json({ data: cart });
  } catch (error) {
    res.status(500).json({ message: "Error fetching cart", error });
  }
});

// [2] Add to Cart
router.post("/cart/:productId", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const productId = req.params.productId;

    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (user.cart.includes(productId)) {
      return res.status(400).json({ message: "Product already in cart" });
    }

    user.cart.push(productId);
    await user.save();

    res.json({ message: "Product added to cart", data: user.cart });
  } catch (error) {
    res.status(500).json({ message: "Error adding to cart", error });
  }
});

// [3] Delete from Cart
router.delete("/cart/:productId", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const productId = req.params.productId;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    user.cart = user.cart.filter((id) => id !== productId);
    await user.save();

    res.json({ message: "Product removed from cart", data: user.cart });
  } catch (error) {
    res.status(500).json({ message: "Error removing from cart", error });
  }
});

// [4] Get Wishlist
router.get("/wishlist", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const wishlisted = await Product.find({ pid: { $in: user.wishlist } });

    res.json({ data: wishlisted });
  } catch (error) {
    res.status(500).json({ message: "Error fetching wishlist", error });
  }
});

// [5] Delete from Wishlist
router.delete("/wishlist/:productId", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const productId = req.params.productId;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    user.wishlist = user.wishlist.filter((id) => id !== productId);
    await user.save();

    res.json({ message: "Product removed from wishlist", data: user.wishlist });
  } catch (error) {
    res.status(500).json({ message: "Error removing from wishlist", error });
  }
});

// [6] Record Interaction
router.post("/interaction", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const interaction = req.body;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const newInteraction = new Interaction(interaction);
    await newInteraction.save();

    if (newInteraction.interactionType == "ADDTOCART") {
      user.cart.push(newInteraction.pid);
      await user.save();
    }

    res.json({ message: "Interaction recorded", data: newInteraction });
  } catch (error) {
    res.status(500).json({ message: "Error recording interaction", error });
  }
});

module.exports = router;
