/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	Index file for the API - NODEJS
**/
import app from './app/app.js';
import dotenv from 'dotenv';
import { connect } from './config/db/connect.js'; 

dotenv.config();

const PORT = process.env.SERVER_PORT || 3000;

// Verifica conexión a BD
connect.getConnection()
  .then(() => console.log(' Base de datos conectada'))
  .catch(err => console.error(' Error BD:', err.message));

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});


/*import app from './app/app.js';
import dotenv from 'dotenv';

dotenv.config();
const PORT = process.env.PORT || 3000; // Allow dynamic port configuration




// Start the server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
}); */
