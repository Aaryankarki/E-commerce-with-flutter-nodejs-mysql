import axios from "axios"
import config from "../config/config.js"

const payViaKhalti=async(data)=>{
  if(!data) throw{messsage:"payment data is required"}
  if(!data.amount) throw{messsage:"payment amount is required"}
  if(!data.purchaseOrderId) throw{message:"orderId  is required"}
  if(!data.purchaseOrderName) throw{messsage:"OrderName is required"}


  const body={

  
    return_url:"http://localhost:3000/khalti/payment",
    amount:data.amount,
   website_url: 'https://dev.khalti.com/api/v2',
   purchase_order_id:data.purchaseOrderId,
   purchase_order_name:data.purchaseOrderName,
 customer_info: {
  name: data.customer.name,
  email: data.customer.email,
  phone: data.customer.phone,
},


  }
  // console.log(config.khalti.apiUrl)
  // console.log(config.name)
  // // console.log("data:jnjnjkkknj",body);
  console.log(config.khalti.apiKey)

const response= await axios.post(`https://dev.khalti.com/api/v2/epayment/initiate/`,
    body
  ,{
    headers:{'Authorization': `Key 6ca6ef59d7f246778c29a869fe0c60b0`, 

    }
  })
  return response.data;
};
export default {payViaKhalti};