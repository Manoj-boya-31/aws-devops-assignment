const express = require("express");
const fs = require("fs");
const { Pool } = require("pg");

const app = express();
const port = process.env.PORT || 3000;
const logFile = process.env.LOG_FILE || "/tmp/app.log";

function log(message) {
  const line = `${new Date().toISOString()} ${message}\n`;
  console.log(line.trim());
  try {
    fs.mkdirSync(require("path").dirname(logFile), { recursive: true });
    fs.appendFileSync(logFile, line);
  } catch (_) {}
}

const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || "devopsdb",
  user: process.env.DB_USER || "devops",
  password: process.env.DB_PASSWORD || "change-me",
  connectionTimeoutMillis: 3000
});

app.get("/", (_req, res) => {
  res.json({
    application: "AWS DevOps Assignment",
    status: "running",
    environment: process.env.APP_ENV || "local",
    timestamp: new Date().toISOString()
  });
});

app.get("/health", (_req, res) => {
  res.status(200).json({ status: "healthy" });
});

app.get("/api/status", async (_req, res) => {
  try {
    const result = await pool.query("SELECT NOW() AS database_time");
    res.json({
      application: "healthy",
      database: "connected",
      database_time: result.rows[0].database_time
    });
  } catch (error) {
    log(`Database check failed: ${error.message}`);
    res.status(503).json({
      application: "healthy",
      database: "unavailable"
    });
  }
});

app.use((_req, res) => {
  res.status(404).json({ error: "Not found" });
});

app.listen(port, () => {
  log(`Application started on port ${port}`);
});

module.exports = app;
