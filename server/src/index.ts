// index.ts starts the server

import app, { initializeDatabase } from "./server";

const port = process.env.PORT || 3000;

Promise.all([initializeDatabase() , 
  // initializeLLMmicroservice()]).then(async () => {
  // await 
  //initializeIngredients()]).then(async () => {
  app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
  })
]);
