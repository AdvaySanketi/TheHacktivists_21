const express = require("express");
const User = require("../models/User");
var jwt = require("jsonwebtoken");
const router = express.Router();
const authenticateToken = require("../middleware/authToken");
const { body, validationResult } = require("express-validator");

//Route 1: Login a User.
router.post(
  "/login",
  [
    body("email", "Enter a valid Email ID").isEmail().exists(),
    body("name", "Name is missing").exists(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    let success = false;
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, name, orcid, key } = req.body;

    try {
      let user = await User.findOne({ email: email });
      if (!user) {
        user = await User.create({
          name: name,
          email: email,
          cart: [],
          wishlist: [],
        });
      }

      const data = {
        id: user.id,
        onboardFinish: user.onboardFinish,
        bid: user.bid,
      };
      success = true;
      res.json({ success, data });
    } catch (error) {
      console.error(error.message);
      res.status(500).send("Some error occured");
    }
  }
);

// Route 2: Set Onboarding Values for a User
router.post(
  "/onboard",
  [
    body("onboardCategories", "onboardCategories is required")
      .isArray()
      .exists(),
    body("onboardSubCategories", "onboardSubCategories is required")
      .isArray()
      .exists(),
  ],
  authenticateToken,
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { onboardCategories, onboardSubCategories } = req.body;

    try {
      let userId = req.user.id;
      let user = await User.findById(userId);
      if (!user) {
        return res
          .status(404)
          .json({ success: false, message: "User not found" });
      }

      user.onboardFinish = "true";
      user.onboardCategories = onboardCategories;
      user.onboardSubCategories = onboardSubCategories;
      await user.save();

      res.json({
        success: true,
        message: "Onboarding values updated successfully",
        user,
      });
    } catch (error) {
      console.error(error.message);
      res.status(500).send("Some error occurred");
    }
  }
);

// Route 3: Get Onboarding Values for a User
router.get("/onboard/get", authenticateToken, async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    let userId = req.user.id;
    let user = await User.findById(userId);
    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    data = {
      onboardCategories: user.onboardCategories,
      onboardSubCategories: user.onboardSubCategories,
    };

    res.json({ success: true, data: data });
  } catch (error) {
    console.error(error.message);
    res.status(500).send("Some error occurred");
  }
});

// Route 4: Delete User's Account
router.delete("/delete", authenticateToken, async (req, res) => {
  try {
    let userId = req.user.id;
    let user = await User.findByIdAndDelete(userId);
    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    res.json({ success: true, message: "User account deleted successfully" });
  } catch (error) {
    console.error(error.message);
    res.status(500).send("Some error occurred");
  }
});

module.exports = router;
