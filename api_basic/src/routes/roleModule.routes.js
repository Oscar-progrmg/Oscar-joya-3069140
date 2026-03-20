import { Router } from 'express';
import { showRoleModule, showRoleModuleId, addRoleModule, updateRoleModule, deleteRoleModule } from '../controllers/roleModule.controller.js';
import { verifyToken } from '../middleware/authMiddleware.js';

const router = Router();
const apiName = '/roleModule';


router.route(apiName)
  .get(verifyToken,showRoleModule) // Get RoleModule
  .post(verifyToken,addRoleModule); // Add RoleModule

router.route(`${apiName}/:id`)
  .get(verifyToken,showRoleModuleId)  // Get RoleModule by Id
  .put(verifyToken,updateRoleModule)  // Update RoleModule by Id
  .delete(verifyToken,deleteRoleModule); // Delete RoleModule by Id

export default router;