import { Router } from 'express';
import { showProfile, showProfileId, addProfile, updateProfile, deleteProfile } from '../controllers/profile.controller.js';
import { verifyToken } from '../middleware/authMiddleware.js';

const router = Router();
const apiName = '/profile';


router.route(apiName)
  .get(verifyToken,showProfile) // Get Profile
  .post(verifyToken,addProfile); // Add Profile

router.route(`${apiName}/:id`)
  .get(verifyToken,showProfileId)  // Get Profile by Id
  .put(verifyToken,updateProfile)  // Update Profile by Id
  .delete(verifyToken,deleteProfile); // Delete Profile by Id

export default router;