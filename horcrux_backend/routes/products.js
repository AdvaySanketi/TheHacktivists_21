const express = require("express");
const User = require("../models/User");
const Product = require("../models/Product");
const Order = require("../models/Order");
const Interaction = require("../models/Interaction");
const authenticateToken = require("../middleware/authToken");
const router = express.Router();

const INTERACTION_WEIGHTS = {
  LIKE: 1,
  DISLIKE: -1,
  ADDTOCART: 2,
};

function recommendProducts(products, interactions) {
  const productScores = new Map();

  interactions.forEach((interaction) => {
    const { pid, interactionType } = interaction;

    const weight = INTERACTION_WEIGHTS[interactionType] || 0;

    if (!productScores.has(pid)) {
      productScores.set(pid, 0);
    }

    productScores.set(pid, productScores.get(pid) + weight);
  });

  const recommendedProducts = products.sort((a, b) => {
    const scoreA = productScores.get(a._id) || 0;
    const scoreB = productScores.get(b._id) || 0;

    return scoreB - scoreA;
  });

  return recommendedProducts;
}

// [1] Get recommended products for User
router.get("/feed", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const user = await User.findById(userId);

    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    const interactions = await Interaction.find({
      uid: user.email,
    });

    const products = await Product.find({});
    const recommended = recommendProducts(products, interactions).slice(0, 20);
    // const recommended = products.slice(0, 20);

    res.json({ data: recommended });
  } catch (error) {
    console.error("Error fetching feed:", error);
    res
      .status(500)
      .json({ message: "Error fetching feed", error: error.message });
  }
});

// [2] Get all products that have the query text in the title
router.get("/search", async (req, res) => {
  const queryText = req.query.q;
  if (!queryText) {
    return res.status(400).json({ message: "Query text is required" });
  }

  try {
    const products = await Product.find({
      name: { $regex: queryText, $options: "i" },
    });
    res.json({ data: products });
  } catch (error) {
    res.status(500).json({ message: "Error searching products", error });
  }
});

// [3] Get the 10 most trending products based on user interactions
router.get("/trending", async (req, res) => {
  try {
    const topInteractions = await Interaction.aggregate([
      {
        $group: {
          _id: "$pid",
          count: { $sum: 1 },
        },
      },
      {
        $sort: { count: -1 },
      },
      {
        $limit: 10,
      },
    ]);

    const topPids = topInteractions.map((interaction) => interaction._id);

    console.log(topPids);

    const trendingProducts = await Product.find({
      pid: { $in: topPids },
    });

    res.json({ data: trendingProducts });
  } catch (error) {
    res.status(500).json({ message: "Error fetching latest products", error });
  }
});

// [4] Get Product based on pid
router.get("/:pid", authenticateToken, async (req, res) => {
  try {
    const { pid } = req.params;

    const product = await Product.findOne({ pid: pid });

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    const userId = req.user.id;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const isInWishlist = user.wishlist.includes(pid);

    res.json({ data: { ...product.toObject(), isInWishlist } });
  } catch (error) {
    res.status(500).json({ message: "Error fetching product", error });
  }
});

module.exports = router;
