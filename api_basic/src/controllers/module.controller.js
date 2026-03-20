import ModuleModel from '../models/module.model.js';

export const showModule = async (req, res) => {
  try {
    const moduleModel = new ModuleModel();
    moduleModel.showModule(res);
  } catch (error) {
    res.status(500).json({ error: "Error fetching Modules", details: error.message });
  }
};

export const showModuleId = async (req, res) => {
  try {
    const moduleModel = new ModuleModel();
    moduleModel.showModuleById(res, req);

  } catch (error) {
    res.status(500).json({ error: "Error fetching Module", details: error.message });
  }
};

export const addModule = async (req, res) => {
  try {
    const moduleModel = new ModuleModel();
    moduleModel.addModule(req, res);

  } catch (error) {
    res.status(500).json({ error: "Error adding Module", details: error.message });
  }
};

export const updateModule = async (req, res) => {
  try {
    const moduleModel = new ModuleModel();
    moduleModel.updateModule(req, res);

  } catch (error) {
    res.status(500).json({ error: "Error updating Module", details: error.message });
  }
};

export const deleteModule = async (req, res) => {
  try {
    const moduleModel = new ModuleModel();
    moduleModel.deleteRModule(req, res);
    
  } catch (error) {
    res.status(500).json({ error: "Error deleting Module", details: error.message });
  }
};