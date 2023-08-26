// Importing express to our app
// Initialisation - Express
const express = require('express');
const app = express();

// Initialisation - Mongoose
const mongoose = require('mongoose');

//Importing the model
const Note = require('./models/Note');

//Importing body-parser
const bodyParser = require('body-parser');
const router = require('./routes/Note_routes');
app.use(bodyParser.urlencoded({extended: false})); //using the body-parser in the app
app.use(bodyParser.json());
// true -> Nested Objects (allowed)
// false -> Nested Objects(not allowed)

const mongoConnectionString = "mongodb+srv://admin00:football1234@cluster0.aqb1kjr.mongodb.net/notesdb";
mongoose.connect(mongoConnectionString).then(function()
{
    // Define App routes
    // Home route (/) 
    app.get("/", function(req, res){
        const response = { statuscode: res.statusCode, message: "Everything works!" };
        res.json(response);
    });

    const noteRouter = require('./routes/Note_routes');
    app.use("/notes", noteRouter); //the noteRouter would be used for the routes for /notes
});



// Starting the server on a port
const PORT = process.env.PORT || 3000; //fetches the port of the environment else assigns port 5000
app.listen(PORT, function(){
    console.log("Server started at PORT : "+PORT); // the function here is optional
});