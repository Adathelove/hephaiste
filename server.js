const express = require("express");
const runHephaiste = require("./runner");

const app = express();
app.use(express.json());

app.post("/run", async (req, res) => {
  const args = req.body.args || [];

  try {
    const result = await runHephaiste(args);
    res.json({
      ok: true,
      args,
      exit: result.code,
      stdout: result.out.trim(),
      stderr: result.err.trim()
    });
  } catch (err) {
    res.status(500).json({
      ok: false,
      error: String(err)
    });
  }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`API listening on ${PORT}`);
});
