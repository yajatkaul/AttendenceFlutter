import mongoose from "mongoose";

//Schema
const attendenceSchema = new mongoose.Schema(
  {
    date: {
      type: String,
      required: true,
    },
    users: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
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
