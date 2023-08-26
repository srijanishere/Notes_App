//Import all the necessary item
const express = require('express');
const router = express.Router();
const Note = require('./../models/Note');

// Notes list route - to find all notes belonging to a particular userid
// here :userid is a parameter whose value can be fetched from req
router.post("/list", async function(req, res){
    var notes = await Note.find({ userid: req.body.userid }); //await is required because find() is a promise
    res.json(notes);
});

//Notes add route - to add and update notes
//here we use a post() request and to access post request we need a front-end
router.post("/add", async function(req, res){
    
    await Note.deleteOne({id: req.body.id}); //UPDATE function : deletes if a note with the id already exists; does not allow duplicate note ids
    
    const newNote = new Note({
        id: req.body.id,
        userid: req.body.userid,
        title: req.body.title,
        content: req.body.content,
    });
    await newNote.save();
    
    const response = { message: "New Note Created -> " + `id: ${req.body.id}` };
    res.json(response);
});

//Notes delete route - to delete a note based on its id
router.post("/delete", async function(req, res){
    await Note.deleteOne({id: req.body.id});
    
    const response = { message: "Note Deleted -> " + `id: ${req.body.id}` };
    res.json(response);
});

//exporting the router
module.exports = router;