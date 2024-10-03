import express from "express";
import { configDotenv } from "dotenv";
import dataRoutes from "./routes/data.routes.js";

configDotenv();
const app = express();
app.use(express.json());

app.use("/api/data", dataRoutes);

app.listen(process.env.PORT || 5000, () => {
  console.log(`Server started at http://localhost:${process.env.PORT || 5000}`);
});
