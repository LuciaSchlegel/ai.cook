import app, { initializeDatabase } from "./server";

const port = process.env.PORT || 3000;

initializeDatabase().then(() => {
    app.listen(port, () => {
        console.log(`Server is running on port ${port}`);
    });
});