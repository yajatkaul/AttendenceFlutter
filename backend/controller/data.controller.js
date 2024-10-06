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
    const { page = 1, limit = 20, start_date, end_date } = req.query;

    // Initialize the query object
    let query = {};

    // Build the date range query if start_date or end_date is provided
    if (start_date || end_date) {
      query.date = {};

      // If start_date is provided, add $gte (greater than or equal to) condition
      if (start_date) {
        query.date.$gte = new Date(start_date);
      }

      // If end_date is provided, add $lte (less than or equal to) condition
      if (end_date) {
        query.date.$lte = new Date(end_date);
      }
    }

    // Fetch attendance records based on the query and pagination
    const attendance = await Attendence.find(query)
      .sort({ date: -1 }) // Optional: sorts the records by date in descending order
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    res.status(200).json(attendance);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const createDates = async (req, res) => {
  try {
    const data = req.body;

    const users = await User.find();
    const presentUsers = await User.find({ _id: { $in: data.users } });

    const newDate = new Attendence({
      date: data.date,
      users: presentUsers,
      total: Object.keys(users).length,
      present: data.users.length,
    });

    await newDate.save();

    res.status(200).json({ result: "Success" });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const getPresent = async (req, res) => {
  try {
    const id = req.params.id;

    const users = await Attendence.findById(id);

    res.status(200).json(users);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const deleteUser = async (req, res) => {
  try {
    const id = req.params.id;

    await User.findByIdAndDelete(id);

    res.status(200).json({ result: "Success" });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Internal server error" });
  }
};
