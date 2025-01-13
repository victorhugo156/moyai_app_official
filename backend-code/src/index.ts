import "dotenv/config";
import { app } from "./app.js";
import { AppDataSource } from "./config/config.js";
import { error } from "console";

AppDataSource.initialize()
  .then(() => {
    app.listen(process.env.PORT || 8000, () => {
      const memoryUsage = process.memoryUsage();
      console.log(`Heap Used: ${memoryUsage.heapUsed / 1024 / 1024} MB`);

      console.log(`Server is Running at, PORT: ${process.env.PORT}`);
    });
  })
  .catch((error) => {
    console.error("Error during Data Source initialization:", error);
  });
