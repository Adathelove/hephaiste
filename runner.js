const { spawn } = require("child_process");
const path = require("path");

module.exports = function runHephaiste(args = []) {
  return new Promise((resolve, reject) => {
    const cliPath = path.join(__dirname, "index.js");

    const child = spawn(cliPath, args, {
      stdio: ["ignore", "pipe", "pipe"]
    });

    let out = "";
    let err = "";

    child.stdout.on("data", d => out += d.toString());
    child.stderr.on("data", d => err += d.toString());

    child.on("close", code => {
      resolve({ code, out, err });
    });

    child.on("error", reject);
  });
};
