import app, { initializeDatabase } from "./server";

const port = 3000;

initializeDatabase().then(() => {
  app.listen(port, '0.0.0.0', () => {
    console.log(`Server is running on http://0.0.0.0:${port}`);
  });
}).catch((err) => {
  console.error("Error initializing database", err);
});