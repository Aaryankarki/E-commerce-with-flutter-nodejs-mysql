const express = require("express");
const { PrismaClient } = require("@prisma/client");
const auth = require("../middlewares/auth.js");

const prisma = new PrismaClient();
const productRouter = express.Router();

// =============================
// GET PRODUCTS BY CATEGORY
// =============================
productRouter.get("/api/products", auth, async (req, res) => {
  try {
    const category = req.query.category;

    const products = await prisma.product.findMany({
      where: { category },
      include: { ratings: true },
    });

    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// =============================
// SEARCH PRODUCTS BY NAME
// =============================
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const name = req.params.name;

    const products = await prisma.product.findMany({
      where: {
        name: {
          contains: name,
          mode: "insensitive", // case-insensitive search
        },
      },
      include: { ratings: true },
    });

    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// =============================
// RATE PRODUCT
// =============================
productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    const userId = req.user;

    // Check if product exists
    const product = await prisma.product.findUnique({
      where: { id },
      include: { ratings: true },
    });

    if (!product) {
      return res.status(404).json({ msg: "Product not found" });
    }

    // Delete existing rating if user has already rated
    await prisma.rating.deleteMany({
      where: {
        productId: id,
        userId: userId,
      },
    });

    // Add new rating
    await prisma.rating.create({
      data: {
        rating,
        productId: id,
        userId,
      },
    });

    // Fetch updated product with all ratings
    const updatedProduct = await prisma.product.findUnique({
      where: { id },
      include: { ratings: true },
    });

    res.json(updatedProduct);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// =============================
// DEAL OF THE DAY
// =============================
productRouter.get("/api/deal-of-day", auth, async (req, res) => {
  try {
    let products = await prisma.product.findMany({
      include: { ratings: true },
    });

    // Sort by total rating sum
    products = products.sort((a, b) => {
      const aSum = a.ratings.reduce((acc, r) => acc + r.rating, 0);
      const bSum = b.ratings.reduce((acc, r) => acc + r.rating, 0);
      return bSum - aSum; // highest rated first
    });

    res.json(products[0] || {});
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = productRouter;
