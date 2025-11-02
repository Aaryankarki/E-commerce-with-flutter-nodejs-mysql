const express = require("express");
const { PrismaClient } = require("@prisma/client");
const authRouter = require("./router/auth.js");
const adminRouter = require("./router/admin.js");
const productRouter = require("./router/product.js");
const userRouter = require("./router/user.js");
const PORT = 3000;

const app = express();
app.use(express.json());


app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);


app.listen(PORT, () => {
  console.log(`the server is running at ${PORT}`);
});
