import { Router } from 'express';
import { aiAssistController } from '../controllers/ai_assist.controller';

const aiAssistRouter = Router();

aiAssistRouter.post('/assist', aiAssistController);

export default aiAssistRouter;
