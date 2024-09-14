const mongoose = require("mongoose");
const dotenv = require('dotenv');
const path = require('path');

dotenv.config({
  path: path.join(__dirname, '.env'),
});

async function connectToMongo() {
  try{
     await mongoose.connect(process.env.MONGO_URL);
     console.log("Connected to Mongo successfully..");

  }catch(error){
    console.log("MongoError-", error);
  }

}

module.exports = connectToMongo;
