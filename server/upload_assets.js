require('dotenv').config();
const cloudinary = require('cloudinary').v2;
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const path = require('path');

cloudinary.config({ 
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME, 
  api_key: process.env.CLOUDINARY_API_KEY, 
  api_secret: process.env.CLOUDINARY_API_SECRET 
});

const carouselImages = [
  'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
  'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
  'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
  'https://images-na.ssl-images-amazon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
  'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
];

const categories = [
  { title: 'Mobiles', file: 'mobiles.jpeg' },
  { title: 'Essentials', file: 'essentials.jpeg' },
  { title: 'Appliances', file: 'appliances.jpeg' },
  { title: 'Books', file: 'books.jpeg' },
  { title: 'Fashion', file: 'fashion.jpeg' },
];

async function run() {
  try {
    console.log('Seeding Carousel Images...');
    await prisma.carousel.deleteMany({});
    for (const url of carouselImages) {
      await prisma.carousel.create({ data: { imageUrl: url } });
    }
    console.log('Carousel Images Seeded.');

    console.log('Uploading and Seeding Category Images...');
    await prisma.category.deleteMany({});
    
    for (const cat of categories) {
      const filePath = path.join(__dirname, '../assets/images', cat.file);
      console.log(`Uploading ${cat.file}...`);
      
      const result = await cloudinary.uploader.upload(filePath, { folder: 'categories' });
      
      await prisma.category.create({
        data: {
          title: cat.title,
          imageUrl: result.secure_url
        }
      });
      console.log(`Uploaded & Seeded ${cat.title}: ${result.secure_url}`);
    }
    
    console.log('All Done!');
  } catch (err) {
    console.error('Error:', err);
  } finally {
    await prisma.$disconnect();
  }
}

run();
