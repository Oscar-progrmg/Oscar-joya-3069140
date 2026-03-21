import { connect } from '../config/db/connect.js';


class ModuleModel {
  constructor(id, name, description, route, icon, submodule, parent_module) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.route = route;
    this.icon = icon;
    this.submodule = submodule;
    this.parent_module = parent_module;
  }

  async addModule(req, res) {
    // Logic to add Module to the database
    try {
      const { name, description, route, icon, submodule, parent_module } = req.body;
      if (!name || !description || !route || !icon || !submodule || !parent_module) {
        return res.status(400).json({ error: "Missing required fields" });
      }
      let sqlQuery = "INSERT INTO modules (Modules_name,Modules_description,Modules_route,Modules_icon,Modules_submodule,Modules_parent_module) VALUES (?,?,?,?,?,?)";
      const [result] = await connect.query(sqlQuery, [name, description, route, icon, submodule, parent_module]);
      res.status(201).json({
        data: [{ id: result.insertId, name, description, route, icon, submodule, parent_module }],
        status: 201
      });
    } catch (error) {
      res.status(500).json({ error: "Error adding Module", details: error.message });
    }
  }

  async updateModule(req, res) {
    // Logic to update Module in the database
    try {
      const { name, description, route, icon, submodule, parent_module } = req.body;
      if (!name || !description || !route || !icon || !submodule || !parent_module) {
        return res.status(400).json({ error: "Missing required fields" });
      }
      let sqlQuery = "UPDATE Modules SET Modules_name=?,Modules_description=?,Modules_route=?,Modules_icon=?,Modules_submodule=?,Modules_parent_module=?,update_at=? WHERE Modules_id= ?";
      const update_at = new Date().toLocaleString("en-CA", { timeZone: "America/Bogota" }).replace(",", "").replace("/", "-").replace("/", "-");
      const [result] = await connect.query(sqlQuery, [name, description, route, icon, submodule, parent_module, update_at, req.params.id]);
      if (result.affectedRows === 0) return res.status(404).json({ error: "Module not found" });
      res.status(200).json({
        data: [{ name, description, route, icon, submodule, parent_module, update_at }],
        status: 200,
        updated: result.affectedRows
      });
    } catch (error) {
      res.status(500).json({ error: "Error updating Module", details: error.message });
    }
  }

  async deleteRModule(req, res) {
    // Logic to delete Module from the database
    try {
      let sqlQuery = "DELETE FROM Modules WHERE Modules_id = ?";
      const [result] = await connect.query(sqlQuery, [req.params.id]);
      if (result.affectedRows === 0) return res.status(404).json({ error: "Module not found" });
      res.status(200).json({
        data: [],
        status: 200,
        deleted: result.affectedRows
      });
    } catch (error) {
      res.status(500).json({ error: "Error deleting Module", details: error.message });
    }
  }


  async showModule(res) {
    // Logic to show Module from the database
    try {
      let sqlQuery = "SELECT * FROM Modules";
      const [result] = await connect.query(sqlQuery);
      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({ error: "Error fetching Modules", details: error.message });
    }
  }
  async showModuleById(res, req) {
    // Logic to show Module from the database by ID
    try {
      const [result] = await connect.query('SELECT * FROM Modules WHERE Modules_id = ?', [req.params.id]);
      if (result.length === 0) return res.status(404).json({ error: "Module not found" });
      res.status(200).json(result[0]);
    } catch (error) {
      res.status(500).json({ error: "Error fetching Module", details: error.message });
    }
  }

}

export default ModuleModel;