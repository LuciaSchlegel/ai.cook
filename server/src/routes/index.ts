import { Router } from "express";
import userRouter from "./user.router";
import adminRouter from "./admin.router";
import analyticsRouter from "./analytics.router";
import attributesRouter from "./attributes.router";
import calendarRouter from "./calendar.router";
import foodRouter from "./food.router";
import recipesRouter from "./recipes.router";

const router = Router();

router.use("/user", userRouter);
router.use("/admin", adminRouter);
router.use("/analytics", analyticsRouter);
router.use("/attributes", attributesRouter);
router.use("/calendar", calendarRouter);
router.use("/food", foodRouter);
router.use("/recipes", recipesRouter);

export default router;