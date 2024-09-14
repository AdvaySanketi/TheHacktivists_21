const jwt = require("jsonwebtoken");
const User = require("../models/User");

async function authenticateToken(req, res, next) {
  const token = req.header("Authorization");
  if (!token) return res.status(401).send({ error: "Access Denied" });

  try {
    var user;
    const verified = jwt.verify(token, "horcrux");

    user = await User.findOne({
      email: verified.email,
    });

    req.user = user;
    next();
  } catch (err) {
    res.status(400).send({ error: "Invalid Token" });
  }
}

module.exports = authenticateToken;
