import { connect } from '../config/db/connect.js';


class RoleModuleModel {
  constructor(id, module, role) {
    this.id = id;
    this.module = module;
    this.role = role;
  }

  async addRoleModule(req, res) {
    // Logic to add RoleModule to the database
    try {
      const { module, role } = req.body;
      if (!module || !role) {
        return res.status(400).json({ error: "Missing required fields" });
      }
      let sqlQuery = "INSERT INTO role_modules (Modules_fk,Roles_fk) VALUES (?,?)";
      const [result] = await connect.query(sqlQuery, [module, role]);
      res.status(201).json({
        data: [{ id: result.insertId, module, role }],
        status: 201
      });
    } catch (error) {
      res.status(500).json({ error: "Error adding RoleModule", details: error.message });
    }
  }

  async updateRoleModule(req, res) {
    // Logic to update RoleModule in the database
    try {
      const { module, role } = req.body;
      if (!module || !role) {
        return res.status(400).json({ error: "Missing required fields" });
      }
      let sqlQuery = "UPDATE role_modules SET Modules_fk=?,Roles_fk=?,update_at=? WHERE RoleModules_id= ?";
      const update_at = new Date().toLocaleString("en-CA", { timeZone: "America/Bogota" }).replace(",", "").replace("/", "-").replace("/", "-");
      const [result] = await connect.query(sqlQuery, [module, role, update_at, req.params.id]);
      if (result.affectedRows === 0) return res.status(404).json({ error: "RoleModule not found" });
      res.status(200).json({
        data: [{ module, role, update_at }],
        status: 200,
        updated: result.affectedRows
      });
    } catch (error) {
      res.status(500).json({ error: "Error updating RoleModule", details: error.message });
    }
  }

  async deleteRoleModule(req, res) {
    // Logic to delete RoleModule from the database
    try {
      let sqlQuery = "DELETE FROM role_modules WHERE RoleModules_id = ?";
      const [result] = await connect.query(sqlQuery, [req.params.id]);
      if (result.affectedRows === 0) return res.status(404).json({ error: "RoleModule not found" });
      res.status(200).json({
        data: [],
        status: 200,
        deleted: result.affectedRows
      });
    } catch (error) {
      res.status(500).json({ error: "Error deleting RoleModule", details: error.message });
    }
  }


  async showRoleModule(res) {
    // Logic to show RoleModule from the database
    try {
      let sqlQuery = "SELECT * FROM role_modules";
      const [result] = await connect.query(sqlQuery);
      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({ error: "Error fetching RoleModules", details: error.message });
    }
  }
  async showRoleModuleById(res, req) {
    // Logic to show RoleModule from the database by ID
    try {
      const [result] = await connect.query('SELECT * FROM role_modules WHERE RoleModules_id = ?', [req.params.id]);
      if (result.length === 0) return res.status(404).json({ error: "RoleModule not found" });
      res.status(200).json(result[0]);
    } catch (error) {
      res.status(500).json({ error: "Error fetching RoleModule", details: error.message });
    }
  }

}

export default RoleModuleModel;