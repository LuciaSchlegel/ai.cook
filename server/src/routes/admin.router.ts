import { RequestHandler, Router } from "express";
import { setAdminRoleController, seedResourcesController, seedIngredientsController, seedRecipesController } from "../controllers/admin.controller";
import { adminAuthMiddleware } from "../middlewares/admin_auth.middleware";

const adminRouter = Router();
// adminRouter.use(adminAuthMiddleware as RequestHandler);

adminRouter.put("/:uid", setAdminRoleController as RequestHandler);
adminRouter.post("/seed/recipes", seedRecipesController as RequestHandler);
adminRouter.post("/seed/ingredients", seedIngredientsController as RequestHandler);
adminRouter.post("/seed/:resourceType", seedResourcesController as RequestHandler);

export default adminRouter;