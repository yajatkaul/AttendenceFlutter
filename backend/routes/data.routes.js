import express from "express";
import { getUsers } from "../controller/data.controller.js";

const router = express.Router();

router.get("/getUsers", getUsers);

router.post("/createUsers", getUsers);

export default router;
