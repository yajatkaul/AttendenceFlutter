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
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        default: [],
      },
    ],
  },
  { timestamps: true }
);

const Attendence = mongoose.model("Attendence", attendenceSchema);

export default Attendence;
