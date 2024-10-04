import express, { Router } from "express";
import {
  createDates,
  createUsers,
  getDates,
  getUsers,
} from "../controller/data.controller.js";

const router = express.Router();

router.get("/getUsers", getUsers);
router.get("/dates", getDates);

router.post("/createDates", createDates);
router.post("/createUsers", createUsers);

export default router;
