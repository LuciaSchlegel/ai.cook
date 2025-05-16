import { Router } from "express";
import userRouter from "./user.router";
import adminRouter from "./admin.router";
import analyticsRouter from "./analytics.router";
import attributesRouter from "./attributes.router";
import calendarRouter from "./calendar.router";
import recipesRouter from "./recipes.router";
import ingredientsRouter from "./ingredients.router";

const router = Router();

router.use("/user", userRouter);
router.use("/admin", adminRouter);
router.use("/analytics", analyticsRouter);
router.use("/attributes", attributesRouter);
router.use("/calendar", calendarRouter);
router.use("/ingredients", ingredientsRouter);
router.use("/recipes", recipesRouter);

export default router;