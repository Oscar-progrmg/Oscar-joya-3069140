import ProfileModel from '../models/profile.model.js';


export const showProfile = async (req, res) => {
  try {
    const profileInstance = new ProfileModel();
    profileInstance.showProfile(res);
  } catch (error) {
    res.status(500).json({ error: "Error fetching profiles , details: error.message" });
  }
};

export const showProfileId = async (req, res) => {
  try {
    const profileInstance = new ProfileModel();
    profileInstance.showProfileById(res, req);
  } catch (error) {
    res.status(500).json({ error: "Error fetching profiles , details: error.message " });
  }
};

export const addProfile = async (req, res) => {
  try {
    const profileInstance = new ProfileModel();
    profileInstance.addProfile(req, res);
  } catch (error) {
    res.status(500).json({ error: "Error adding profile", details: error.message });
  }
};

export const updateProfile = async (req, res) => {
  try {
    const profileInstance = new ProfileModel();
    profileInstance.updateProfile(req, res);
  } catch (error) {
    res.status(500).json({ error: "Error updating profile", details: error.message });
  }
};

export const deleteProfile = async (req, res) => {
  try {
    const profileInstance = new ProfileModel();
    profileInstance.deleteProfile(req, res);
  } catch (error) {
    res.status(500).json({ error: "Error deleting profile", details: error.message });
  }
};