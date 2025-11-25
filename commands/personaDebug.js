const fs = require("fs");
const path = require("path");
const { PersonaSchema } = require("../schemas/persona.schema.js");

module.exports = function personaDebug(name, opts) {
  const dir = opts.personaDir;
  if (!dir) {
    console.error("Missing --persona-dir <path>");
    process.exit(1);
  }

  const file = path.join(dir, `${name}.json`);
  if (!fs.existsSync(file)) {
    console.error(`Persona JSON not found: ${file}`);
    process.exit(1);
  }

  const json = JSON.parse(fs.readFileSync(file, "utf8"));

  try {
    const persona = PersonaSchema.parse(json);
    console.log("Persona JSON is valid:");
    console.log(JSON.stringify(persona, null, 2));
  } catch (err) {
    console.error("Persona JSON is INVALID:");
    console.error(JSON.stringify(err.errors, null, 2));
    process.exit(1);
  }
};
