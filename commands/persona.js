const fs = require("fs");
const path = require("path");

module.exports = function persona(action, name, opts) {
  const dir = opts.personaDir;

  // 1. Validate persona directory
  if (!dir) {
    console.error("hephaiste persona: missing --persona-dir <path>");
    process.exit(1);
  }

  if (!fs.existsSync(dir) || !fs.statSync(dir).isDirectory()) {
    console.error(`hephaiste persona: invalid directory: ${dir}`);
    process.exit(1);
  }

  // 2. Only support 'debug' for now
  if (action !== "debug") {
    console.error(`hephaiste persona: unknown action '${action}'`);
    process.exit(1);
  }

  // 3. Build path to JSON config
  const jsonFile = path.join(dir, `${name}.json`);

  if (!fs.existsSync(jsonFile)) {
    console.error(`hephaiste persona debug: missing config ${jsonFile}`);
    process.exit(1);
  }

  // 4. If it exists, read and pretty-print (future behavior)
  const data = JSON.parse(fs.readFileSync(jsonFile, "utf8"));
  console.log(JSON.stringify(data, null, 2));
};
