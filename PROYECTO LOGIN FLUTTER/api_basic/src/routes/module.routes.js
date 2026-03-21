import {Router} from 'express';
import { verifyToken } from '../middleware/authMiddleware.js';
import {showModule,showModuleId,addModule,updateModule,deleteModule} from '../controllers/module.controller.js';

const router=Router();
const apiName='/module';

router.route(apiName)
  .get(verifyToken,showModule)  // Get all Module
  .post(verifyToken,addModule); // Add Module

router.route(`${apiName}/:id`)
  .get(verifyToken,showModuleId)  // Get Module by Id
  .put(verifyToken,updateModule)  // Update Module by Id
  .delete(verifyToken,deleteModule); // Delete Module by Id

export default router;