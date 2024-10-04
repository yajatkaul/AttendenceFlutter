import mongoose from "mongoose";

//Schema
const userSchema = new mongoose.Schema(
  {
    displayName: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);

export default User;
