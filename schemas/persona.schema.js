const { z } = require("zod");

const PersonaSchema = z.object({
  name: z.string(),
  clasp: z.string(),
  focus: z.string().optional(),
  inheritsFrom: z.array(z.string()).optional(),
  baseFile: z.string().optional()
});

module.exports = { PersonaSchema };
