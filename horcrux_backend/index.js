const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const path = require("path");
const rfs = require("rotating-file-stream");
const helmet = require("helmet");
const dotenv = require("dotenv");

dotenv.config({
  path: path.join(__dirname, ".env"),
});

// Environment Variables or Defaults
const NODE_ENV = process.env.NODE_ENV || "development";
const PORT = process.env.PORT || 5000;
const CORS_ORIGIN = process.env.CORS_ORIGIN || "*";
const nodeServerSupportContact = "Team Hacktivists";

// Constants
const consoleLogColors = require("./constants/consoleLogColors");
const httpCodes = require("./constants/httpCodes");
const uptime = require("./middleware/uptime");

// Express App
const app = express();

// Express App
app.use(express.json());

// Helmet
app.use(helmet());

// Logs to file
if (NODE_ENV === "production") {
  const accessLogStream = rfs.createStream("access.log", {
    interval: "1d",
    compress: "gzip",
    path: path.join(__dirname, "logs"),
  });
  app.use(
    morgan(
      '[:date[iso]] ":method :url HTTP/:http-version" :status :res[content-length]ms',
      { stream: accessLogStream }
    )
  );
}
app.use(
  morgan(
    '[:date[iso]] ":method :url HTTP/:http-version" :status :res[content-length]ms'
  )
);

// CORS Options
app.use(cors());
const corsOptions = {
  origin: CORS_ORIGIN,
  optionsSuccessStatus: httpCodes.OK,
};

// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Default Route
app.all("/", (req, res) => {
  res.status(httpCodes.OK).json({
    status: httpCodes.OK,
    message: `Welcome to the The Hacktivists <<Horcrux>> API, any issues contact: ${nodeServerSupportContact}`,
  });
});

// Health Check
app.all("/health", (req, res) => {
  const data = {
    status: httpCodes.OK,
    message: "Server is running",
    uptime: uptime(process.uptime()),
    date: new Date(),
    support: nodeServerSupportContact,
    "API Version": "1.0.0",
  };
  res.status(httpCodes.OK).json(data);
});

// Routes
app.use("/api/auth", require("./routes/auth"));
app.use("/api/products", require("./routes/products"));
app.use("/api/user", require("./routes/user"));
app.use("/api/orders", require("./routes/orders"));

// Error Handling
app.use((err, req, res, next) => {
  console.error(
    `${consoleLogColors.FgRed}`,
    err.stack,
    `${consoleLogColors.Reset}`
  );
  res.status(httpCodes.INTERNAL_SERVER_ERROR).json({
    status: httpCodes.INTERNAL_SERVER_ERROR,
    message: `Something Broke, Contact Us at: ${nodeServerSupportContact}`,
  });
});

// 404 Not Found
app.all("*", function (req, res) {
  res.status(httpCodes.NOT_FOUND).json({
    status: httpCodes.NOT_FOUND,
    message: `404 Not Found, Contact Us at: ${nodeServerSupportContact}`,
  });
});

// Database
const db = require("./db");
db();

// Start Server
app.listen(PORT, () => {
  console.info(
    `${consoleLogColors.FgGreen}`,
    `\nHacktivists<<Horcrux>>-Server is running on Port: ${PORT} \nEnvironment: ${NODE_ENV}`,
    `${consoleLogColors.Reset}`
  );
});

module.exports = app;
