const express = require("express");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
const auth = require("../middlewares/auth.js");

const prisma = new PrismaClient();
const authRouter = express.Router();

// ===========================
// SIGN UP
// ===========================
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) return res.status(400).json({ msg: "User with same email already exists" });

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
      data: { name, email, password: hashedPassword },
    });

    res.status(200).json({ msg: 'User created successfully', user });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ===========================
// SIGN IN
// ===========================
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) return res.status(400).json({ msg: "User with this email does not exist" });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ msg: "Incorrect password" });

    const token = jwt.sign({ id: user.id }, "passwordKey", { expiresIn: "1d" });

    res.json({ token, user });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ===========================
// TOKEN VALIDATION
// ===========================
authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await prisma.user.findUnique({ where: { id: verified.id } });
    if (!user) return res.json(false);

    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ===========================
// GET USER DATA (Protected)
// ===========================
authRouter.get("/", auth, async (req, res) => {
  try {
    const user = await prisma.user.findUnique({ where: { id: req.user } });
    res.json({ ...user, token: req.token });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
