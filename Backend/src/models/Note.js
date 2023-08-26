// Creating a mongoose model
// Steps
// 1. Define Schema -> Note : id, userid, title, content, dateadded
// 2. Create Model -> <model name> <schema>

const mongoose = require('mongoose');

// Defining Schema
const noteSchema = mongoose.Schema({
    id: {
        type: String,
        unique: true,
        required: true
    },
    userid: {
        type: String,
        required: true
    },
    title: {
        type: String,
        required: true
    },
    content: {
        type: String,
    },
    dateadded: {
        type: Date,
        default: Date.now,  
    }
});

//Creating a model using the schema and exporting it
module.exports = mongoose.model("Note", noteSchema);