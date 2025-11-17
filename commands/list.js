const fs = require('fs');
const path = require('path');

module.exports = function list(what, opts) {
    const dir = opts.personaDir;

    // 1) Missing directory
    if (!dir) {
        console.error("hephaiste list: missing --persona-dir <path>");
        process.exit(1);
    }

    // 2) Directory doesn't exist
    if (!fs.existsSync(dir)) {
        console.error(`hephaiste list: directory does not exist: ${dir}`);
        process.exit(1);
    }

    // 3) Not a directory
    if (!fs.statSync(dir).isDirectory()) {
        console.error(`hephaiste list: path is not a directory: ${dir}`);
        process.exit(1);
    }

    // 4) Only implement the "personas" variant for now
    if (what !== "personas") {
        console.error(`hephaiste list: unknown list target '${what}'`);
        process.exit(1);
    }

    // 5) Read directory contents
    const files = fs.readdirSync(dir);

    // 6) Filter for *.Settings.md
    const personas = files
        .filter(f => f.endsWith(".Settings.md"))
        .map(f => f.replace(/\.Settings\.md$/, ""));

    // 7) No persona files
    if (personas.length === 0) {
        console.error("hephaiste list: no persona settings found in directory");
        process.exit(1);
    }

    // 8) Output the list
    personas.forEach(p => console.log(p));
};

