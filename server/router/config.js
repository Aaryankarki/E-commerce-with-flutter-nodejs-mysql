const express = require('express');
const { PrismaClient } = require('@prisma/client');
const configRouter = express.Router();
const prisma = new PrismaClient();

configRouter.get('/api/config', async (req, res) => {
  try {
    const carousels = await prisma.carousel.findMany();
    const categories = await prisma.category.findMany();

    res.json({
      carouselImages: carousels.map(c => c.imageUrl),
      categories: categories.map(c => ({ title: c.title, image: c.imageUrl }))
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = configRouter;
