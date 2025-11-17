const fs = require('fs');
const path = require('path');

module.exports = function inspect(persona, opts) {
    const dir = opts.personaDir;

    // 1) Directory validation
    if (!dir) {
        console.error("hephaiste inspect: missing --persona-dir <path>");
        process.exit(1);
    }

    if (!fs.existsSync(dir) || !fs.statSync(dir).isDirectory()) {
        console.error(`hephaiste inspect: invalid directory: ${dir}`);
        process.exit(1);
    }

    // 2) Build filename
    const filename = path.join(dir, `${persona}.Settings.md`);

    if (!fs.existsSync(filename)) {
        console.error(`hephaiste inspect: no persona file found: ${filename}`);
        process.exit(1);
    }

    // 3) Read file
    const content = fs.readFileSync(filename, 'utf8');

    // 4) Find headings — lines that start with '#'
    const lines = content.split(/\r?\n/);

    const components = lines
        .filter(line => line.trim().startsWith('#'))
        .map(line => line.replace(/^#+\s*/, '').trim());

    if (components.length === 0) {
        console.error(`hephaiste inspect: no components found in ${persona}`);
        process.exit(1);
    }

    // 5) Output
    components.forEach(c => console.log(c));
};

