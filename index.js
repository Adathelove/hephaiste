#!/usr/bin/env node

const { Select } = require('enquirer');


const args = process.argv.slice(2);

// Simple command
if (args[0] === "greet") {
    const nameIndex = args.indexOf("--name");
    const name = nameIndex !== -1 ? args[nameIndex + 1] : "friend";
    console.log(`Forge greets you, ${name}.`);
    process.exit(0);
}

// TUI command
if (args[0] === "menu") {
    const prompt = new Select({
        name: 'action',
        message: 'Choose your strike',
        choices: [
            'Greet',
            'Clean',
            'Purge',
            'Run Tests'
        ]
    });

    prompt.run().then(answer => {
        switch (answer) {
            case "Greet":
                console.log("Hello from the forge.");
                break;
            case "Clean":
                console.log("Running clean...");
                break;
            case "Purge":
                console.log("Running purge...");
                break;
            case "Run Tests":
                console.log("Running tests...");
                break;
        }
    });
    return;
}

console.log("Hephaiste command not recognized.");

