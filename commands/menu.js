
const { Select } = require('enquirer');

module.exports = async function menu() {
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

    const answer = await prompt.run();

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
};

