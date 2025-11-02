const express = require("express");
const { PrismaClient } = require("@prisma/client");
const auth = require("../middlewares/auth.js");

const prisma = new PrismaClient();
const userRouter = express.Router();

// ===============================
// ADD TO CART
// ===============================
userRouter.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const { id } = req.body;
    const userId = req.user;

    const product = await prisma.product.findUnique({
      where: { id },
    });

    if (!product) return res.status(404).json({ msg: "Product not found" });

    const existingItem = await prisma.cartItem.findFirst({
      where: {
        userId,
        productId: id,
      },
    });

    if (existingItem) {
      // Increase quantity
      await prisma.cartItem.update({
        where: { id: existingItem.id },
        data: { quantity: { increment: 1 } },
      });
    } else {
      // Add new item to cart
      await prisma.cartItem.create({
        data: {
          userId,
          productId: id,
          quantity: 1,
        },
      });
    }

    const updatedCart = await prisma.cartItem.findMany({
      where: { userId },
      include: { product: true },
    });

    res.json(updatedCart);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ===============================
// REMOVE FROM CART
// ===============================
userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params; // productId
    const userId = req.user;

    const cartItem = await prisma.cartItem.findFirst({
      where: { userId, productId: id },
    });

    if (!cartItem) {
      return res.status(404).json({ msg: "Item not in cart" });
    }

    if (cartItem.quantity === 1) {
      await prisma.cartItem.delete({
        where: { id: cartItem.id },
      });
    } else {
      await prisma.cartItem.update({
        where: { id: cartItem.id },
        data: { quantity: { decrement: 1 } },
      });
    }

    const updatedCart = await prisma.cartItem.findMany({
      where: { userId },
      include: { product: true },
    });

    res.json(updatedCart);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ===============================
// SAVE USER ADDRESS
// ===============================
userRouter.post("/api/save-user-address", auth, async (req, res) => {
  try {
    const { address } = req.body;

    const user = await prisma.user.update({
      where: { id: req.user },
      data: { address },
    });

    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ===============================
// PLACE ORDER
// ===============================
userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body;
    const userId = req.user;
    let products = [];

    for (const item of cart) {
      const product = await prisma.product.findUnique({
        where: { id: item.product.id },
      });

      if (!product || product.quantity < item.quantity) {
        return res.status(400).json({ msg: `${product?.name || "Product"} is out of stock` });
      }

      // Decrease product stock
      await prisma.product.update({
        where: { id: product.id },
        data: { quantity: product.quantity - item.quantity },
      });

      products.push({
        productId: product.id,
        quantity: item.quantity,
      });
    }

    // Clear user's cart
    await prisma.cartItem.deleteMany({
      where: { userId },
    });

    // Create order and order products
    const order = await prisma.order.create({
      data: {
        userId,
        totalPrice,
        address,
        orderedAt: new Date(),
        products: {
          create: products.map((p) => ({
            productId: p.productId,
            quantity: p.quantity,
          })),
        },
      },
      include: { products: { include: { product: true } } },
    });

    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ===============================
// GET USER ORDERS
// ===============================
userRouter.get("/api/orders/me", auth, async (req, res) => {
  try {
    const orders = await prisma.order.findMany({
      where: { userId: req.user },
      include: { products: { include: { product: true } } },
      orderBy: { orderedAt: "desc" },
    });

    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = userRouter;
