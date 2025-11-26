const fs = require("fs");
const path = require("path");
const { PersonaSchema } = require("../schemas/persona.schema.js");

class PersonaDir {
  constructor(dir) {
    if (!dir) {
      throw new Error("Missing --persona-dir <path>");
    }
    if (!fs.existsSync(dir) || !fs.statSync(dir).isDirectory()) {
      throw new Error(`Invalid persona directory: ${dir}`);
    }
    this.dir = dir;
  }

  filePath(filename) {
    return path.join(this.dir, filename);
  }

  readJson(filename) {
    const full = this.filePath(filename);
    if (!fs.existsSync(full)) {
      throw new Error(`JSON file not found: ${full}`);
    }
    return JSON.parse(fs.readFileSync(full, "utf8"));
  }
}

class Persona {
  constructor(name, personaDir) {
    this.name = name;
    this.dir = personaDir;

    const raw = this.dir.readJson(`${name}.json`);
    this.raw = raw;
  }

  validate() {
    this.data = PersonaSchema.parse(this.raw);
    return this.data;
  }

  print() {
    console.log("Persona JSON is valid:");
    console.log(JSON.stringify(this.data, null, 2));
  }

  loadBase() {
    if (!this.data.baseFile) return;

    const baseJson = this.dir.readJson(this.data.baseFile);

    console.log(`Loaded base JSON: ${this.data.baseFile}`);
    console.log(JSON.stringify(baseJson, null, 2));

    return baseJson;
  }
}

module.exports = { PersonaDir, Persona };
