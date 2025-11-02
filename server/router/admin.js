const express = require('express');
const admin = require('../middlewares/admin.js');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();
const adminRouter = express.Router();

// =========================
// ADD PRODUCT
// =========================
adminRouter.post('/admin/add-product', admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;

    const product = await prisma.product.create({
      data: {
        name,
        description,
        images,
        quantity,
        price,
        category,
      },
    });

    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// =========================
// GET PRODUCTS
// =========================
adminRouter.get('/admin/get-products', admin, async (req, res) => {
  try {
    const products = await prisma.product.findMany();
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// =========================
// DELETE PRODUCT
// =========================
adminRouter.delete('/admin/delete-product', admin, async (req, res) => {
  try {
    const { id } = req.body;

    const product = await prisma.product.delete({
      where: { id },
    });

    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// =========================
// GET ORDERS
// =========================
adminRouter.get('/admin/get-orders', admin, async (req, res) => {
  try {
    const orders = await prisma.order.findMany({
      include: {
        products: {
          include: {
            product: true,
          },
        },
      },
    });
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// =========================
// CHANGE ORDER STATUS
// =========================
adminRouter.post('/admin/change-order-status', admin, async (req, res) => {
  try {
    const { id, status } = req.body;

    const order = await prisma.order.update({
      where: { id },
      data: { status },
      include: {
        products: {
          include: { product: true },
        },
      },
    });

    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// =========================
// ANALYTICS
// =========================
adminRouter.get('/admin/analytics', admin, async (req, res) => {
  try {
    const orders = await prisma.order.findMany({
      include: {
        products: {
          include: { product: true },
        },
      },
    });

    let totalEarnings = 0;
    for (const order of orders) {
      for (const item of order.products) {
        totalEarnings += item.quantity * item.product.price;
      }
    }

    const mobileEarnings = await fetchCategoryWiseEarnings('Mobiles');
    const essentialEarnings = await fetchCategoryWiseEarnings('Essentials');
    const applianceEarnings = await fetchCategoryWiseEarnings('Appliances');
    const booksEarnings = await fetchCategoryWiseEarnings('Books');
    const fashionEarnings = await fetchCategoryWiseEarnings('Fashions');

    const earnings = {
      totalEarnings,
      mobileEarnings,
      essentialEarnings,
      applianceEarnings,
      booksEarnings,
      fashionEarnings,
    };

    res.json(earnings);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// =========================
// Helper: Category Earnings
// =========================
async function fetchCategoryWiseEarnings(category) {
  const categoryOrders = await prisma.order.findMany({
    include: {
      products: {
        include: {
          product: true,
        },
      },
    },
  });

  let earnings = 0;
  for (const order of categoryOrders) {
    for (const item of order.products) {
      if (item.product.category === category) {
        earnings += item.quantity * item.product.price;
      }
    }
  }
  return earnings;
}

module.exports = adminRouter;
