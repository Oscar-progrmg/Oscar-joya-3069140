import RoleModuleModel from '../models/roleModule.model.js';


export const showRoleModule = async (req, res) => {
  try {
    const roleModuleInstance = new RoleModuleModel();
    roleModuleInstance.showRoleModule(res);
  } catch (error) {
    res.status(500).json({ error: "Error fetching roleModules , details: error.message" });
  }
};

export const showRoleModuleId = async (req, res) => {
  try {
    const roleModuleInstance = new RoleModuleModel();
    roleModuleInstance.showRoleModuleById(res, req);
  } catch (error) {
    res.status(500).json({ error: "Error fetching roleModules , details: error.message " });
  }
};

export const addRoleModule = async (req, res) => {
  try {
    const roleModuleInstance = new RoleModuleModel();
    roleModuleInstance.addRoleModule(req, res);
  } catch (error) {
    res.status(500).json({ error: "Error adding roleModule", details: error.message });
  }
};

export const updateRoleModule = async (req, res) => {
  try {
    const roleModuleInstance = new RoleModuleModel();
    roleModuleInstance.updateRoleModule(req, res);
  } catch (error) {
    res.status(500).json({ error: "Error updating roleModule", details: error.message });
  }
};

export const deleteRoleModule = async (req, res) => {
  try {
    const roleModuleInstance = new RoleModuleModel();
    roleModuleInstance.deleteRoleModule(req, res);
  } catch (error) {
    res.status(500).json({ error: "Error deleting roleModule", details: error.message });
  }
};