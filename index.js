#!/usr/bin/env node

const args = process.argv.slice(2);
const command = args[0];

// Command table
const commands = {
    greet: require('./commands/greet'),
    menu: require('./commands/menu'),
    catcher: require('./commands/catcher')
};

if (commands[command]) {
    // Run command with args
    commands[command](args);
} else {
    console.log("Hephaiste: Unknown command.");
    console.log("Try: hephaiste greet --name Ada");
}

