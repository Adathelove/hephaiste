const { PersonaDir, Persona } = require("../lib/persona-utils");

module.exports = function personaDebug(name, opts) {
  const dir = new PersonaDir(opts.personaDir);
  const persona = new Persona(name, dir);

  persona.validate();     // Zod validation
  persona.print();        // JSON.stringify validated persona

  persona.loadBase();     // loads & prints the base JSON if present
};
