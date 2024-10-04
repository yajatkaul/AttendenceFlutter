import Attendence from "../models/attendence.model.js";
import User from "../models/user.models.js";

export const getUsers = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;

    const users = await User.find()
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    res.status(200).json(users);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const createUsers = async (req, res) => {
  try {
    const data = req.body;

    const newUser = new User({
      displayName: data.displayName,
    });

    await newUser.save();

    res.status(200).json({ result: "Success" });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const getDates = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;

    const attendence = await Attendence.find()
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    res.status(200).json(attendence);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const createDates = async (req, res) => {
  try {
    const data = req.body;

    const newDate = new Attendence({
      date: data.date,
      users: data.users,
    });

    await newDate.save();

    res.status(200).json({ result: "Success" });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Internal server error" });
  }
};
