#!/usr/bin/env node

const args = process.argv.slice(2);

if (args[0] === "greet") {
    const nameIndex = args.indexOf("--name");
    const name = nameIndex !== -1 ? args[nameIndex + 1] : "friend";
    console.log(`Forge greets you, ${name}.`);
    process.exit(0);
}

console.log("Hephaiste: no command given. Try: hephaiste greet --name Ada");

