import mongoose from "mongoose";

//Schema
const attendenceSchema = new mongoose.Schema(
  {
    date: {
      type: Date,
      required: true,
    },
    users: [
      {
        type: Array,
        default: [],
      },
    ],
    total: {
      type: String,
      required: true,
    },
    present: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

const Attendence = mongoose.model("Attendence", attendenceSchema);

export default Attendence;
