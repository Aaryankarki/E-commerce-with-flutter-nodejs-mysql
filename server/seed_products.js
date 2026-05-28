require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const sampleProducts = [
  {
    name: 'iPhone 15 Pro Max',
    description: 'Apple iPhone 15 Pro Max with A17 Pro chip, 256GB storage, Titanium design, and advanced camera system.',
    quantity: 25,
    price: 1199.99,
    category: 'Mobiles',
    images: [
      'https://res.cloudinary.com/dz5rms9di/image/upload/v1/products/iphone15pro.jpg',
      'https://images-na.ssl-images-amazon.com/images/I/61L1ItFgFHL._SL1500_.jpg'
    ]
  },
  {
    name: 'Samsung Galaxy S24 Ultra',
    description: 'Samsung Galaxy S24 Ultra with Snapdragon 8 Gen 3, 200MP camera, S Pen, and AI features.',
    quantity: 30,
    price: 1099.99,
    category: 'Mobiles',
    images: [
      'https://images-na.ssl-images-amazon.com/images/I/71sa3dqq8tL._SL1500_.jpg',
      'https://images-na.ssl-images-amazon.com/images/I/71CfuCMPb5L._SL1500_.jpg'
    ]
  },
  {
    name: 'OnePlus 12',
    description: 'OnePlus 12 with Snapdragon 8 Gen 3, 50MP Hasselblad camera, 100W charging.',
    quantity: 40,
    price: 799.99,
    category: 'Mobiles',
    images: [
      'https://images-na.ssl-images-amazon.com/images/I/61mnl3oRu3L._SL1500_.jpg'
    ]
  },
  {
    name: 'Atomic Habits by James Clear',
    description: 'An easy and proven way to build good habits and break bad ones. #1 New York Times bestseller.',
    quantity: 100,
    price: 11.98,
    category: 'Books',
    images: [
      'https://images-na.ssl-images-amazon.com/images/I/81bGKUa1e0L._SL1500_.jpg',
      'https://images-na.ssl-images-amazon.com/images/I/71F3AxRCBpL._SL1500_.jpg'
    ]
  },
  {
    name: 'The Psychology of Money',
    description: 'Timeless lessons on wealth, greed, and happiness by Morgan Housel.',
    quantity: 80,
    price: 14.99,
    category: 'Books',
    images: [
      'https://images-na.ssl-images-amazon.com/images/I/71TRUbzcvaL._SL1500_.jpg'
    ]
  },
  {
    name: 'Dyson V15 Detect Vacuum',
    description: 'Dyson V15 Detect cordless vacuum with laser dust detection and HEPA filtration.',
    quantity: 15,
    price: 749.99,
    category: 'Appliances',
    images: [
      'https://images-na.ssl-images-amazon.com/images/I/61UYQ23WKIL._SL1500_.jpg'
    ]
  },
  {
    name: 'Instant Pot Duo 7-in-1',
    description: 'Electric pressure cooker, slow cooker, rice cooker, steamer, sauté pan, yogurt maker and warmer.',
    quantity: 50,
    price: 89.99,
    category: 'Appliances',
    images: [
      'https://images-na.ssl-images-amazon.com/images/I/71V1LiAoY-L._SL1500_.jpg'
    ]
  },
  {
    name: 'Nivea Body Lotion Gift Set',
    description: 'Nivea Essentially Enriched body lotion set for dry to very dry skin, 48H moisture.',
    quantity: 200,
    price: 19.99,
    category: 'Essentials',
    images: [
      'https://images-na.ssl-images-amazon.com/images/I/61dPDRliYcL._SL1000_.jpg'
    ]
  },
  {
    name: 'First Aid Kit - 299 Pieces',
    description: 'Comprehensive first aid kit for home, office, car, hiking, and camping emergencies.',
    quantity: 60,
    price: 29.99,
    category: 'Essentials',
    images: [
      'https://images-na.ssl-images-amazon.com/images/I/71fSGNKSk-L._SL1500_.jpg'
    ]
  },
  {
    name: 'Nike Air Max 270',
    description: 'Nike Air Max 270 men\'s running shoes with Max Air cushioning for all-day comfort.',
    quantity: 35,
    price: 150.00,
    category: 'Fashion',
    images: [
      'https://images-na.ssl-images-amazon.com/images/I/61mAEhMJkBL._AC_UL1500_.jpg'
    ]
  },
  {
    name: 'Levi\'s 501 Original Fit Jeans',
    description: 'Levi\'s 501 Original Fit men\'s jeans - the original button fly, straight leg.',
    quantity: 45,
    price: 59.99,
    category: 'Fashion',
    images: [
      'https://images-na.ssl-images-amazon.com/images/I/51v0bdar3dL._AC_UL1500_.jpg'
    ]
  }
];

async function seed() {
  try {
    console.log('Seeding products...');
    for (const p of sampleProducts) {
      await prisma.product.create({
        data: {
          name: p.name,
          description: p.description,
          quantity: p.quantity,
          price: p.price,
          category: p.category,
          images: p.images,
        }
      });
      console.log(`  ✓ ${p.name}`);
    }
    const count = await prisma.product.count();
    console.log(`\nDone! ${count} products in database.`);
  } catch (e) {
    console.error('Error:', e.message);
  } finally {
    await prisma.$disconnect();
  }
}

seed();
