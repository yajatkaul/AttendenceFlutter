import express, { Router } from "express";
import {
  createDates,
  createUsers,
  deleteUser,
  getDates,
  getPresent,
  getUsers,
} from "../controller/data.controller.js";

const router = express.Router();

router.get("/getUsers", getUsers);
router.get("/dates", getDates);

router.post("/createDates", createDates);
router.post("/createUsers", createUsers);

router.get("/getPresent/:id", getPresent);
router.get("/deleteUser/:id", deleteUser);

export default router;
