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

    const productIdInt = parseInt(id);

    const product = await prisma.product.findUnique({
      where: { id: productIdInt },
    });

    if (!product) return res.status(404).json({ msg: "Product not found" });

    const existingItem = await prisma.cart.findFirst({
      where: {
        userId,
        productId: productIdInt,
      },
    });

    if (existingItem) {
      // Increase quantity
      await prisma.cart.update({
        where: { id: existingItem.id },
        data: { quantity: { increment: 1 } },
      });
    } else {
      // Add new item to cart
      await prisma.cart.create({
        data: {
          userId,
          productId: productIdInt,
          quantity: 1,
        },
      });
    }

    const updatedCart = await prisma.cart.findMany({
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

    const cartItem = await prisma.cart.findFirst({
      where: { userId, productId: parseInt(id) },
    });

    if (!cartItem) {
      return res.status(404).json({ msg: "Item not in cart" });
    }

    if (cartItem.quantity === 1) {
      await prisma.cart.delete({
        where: { id: cartItem.id },
      });
    } else {
      await prisma.cart.update({
        where: { id: cartItem.id },
        data: { quantity: { decrement: 1 } },
      });
    }

    const updatedCart = await prisma.cart.findMany({
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
        where: { id: parseInt(item.product.id) },
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
    await prisma.cart.deleteMany({
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
// BUY NOW (Single Product Order)
// ===============================
userRouter.post("/api/buy-now", auth, async (req, res) => {
  try {
    const { product, totalPrice, address } = req.body;
    const userId = req.user;
    
    const dbProduct = await prisma.product.findUnique({
      where: { id: parseInt(product.id) },
    });

    if (!dbProduct || dbProduct.quantity < 1) {
      return res.status(400).json({ msg: `${dbProduct?.name || "Product"} is out of stock` });
    }

    // Decrease product stock
    await prisma.product.update({
      where: { id: dbProduct.id },
      data: { quantity: dbProduct.quantity - 1 },
    });

    // Create order for single product without clearing cart
    const order = await prisma.order.create({
      data: {
        userId,
        totalPrice,
        address,
        orderedAt: new Date(),
        products: {
          create: [{
            productId: dbProduct.id,
            quantity: 1,
          }],
        },
      },
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
// ===============================
// ADD TO FAVORITES
// ===============================
userRouter.post('/api/add-favorite', auth, async (req, res) => {
  try {
    const { id } = req.body; // product id
    const userId = req.user;
    const productIdInt = parseInt(id);
    // fetch user
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) return res.status(404).json({ msg: "User not found" });
    // update favorites array, avoid duplicates
    const currentFavs = Array.isArray(user.favorites) ? user.favorites : [];
    const newFavs = [...new Set([...currentFavs, productIdInt])];
    const updated = await prisma.user.update({
      where: { id: userId },
      data: { favorites: newFavs },
    });
    res.json(updated);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ===============================
// REMOVE FROM FAVORITES
// ===============================
userRouter.delete('/api/remove-favorite/:id', auth, async (req, res) => {
  try {
    const productIdInt = parseInt(req.params.id);
    const userId = req.user;
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) return res.status(404).json({ msg: "User not found" });
    const newFav = (Array.isArray(user.favorites) ? user.favorites : []).filter((fid) => fid !== productIdInt);
    const updated = await prisma.user.update({
      where: { id: userId },
      data: { favorites: newFav },
    });
    res.json(updated);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ===============================
// GET FAVORITES
// ===============================
userRouter.get('/api/favorites', auth, async (req, res) => {
  try {
    const userId = req.user;
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) return res.status(404).json({ msg: "User not found" });

    const favoriteIds = Array.isArray(user.favorites) ? user.favorites : [];
    
    const products = await prisma.product.findMany({
      where: { id: { in: favoriteIds } },
      include: { ratings: true },
    });
    
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = userRouter;
