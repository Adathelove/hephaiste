
const fs = require("fs");
const os = require("os");
const path = require("path");
const { exec } = require("child_process");

module.exports = function catchInput() {
    let data = "";

    process.stdin.setEncoding("utf8");
    process.stdin.on("data", chunk => {
        data += chunk;
    });

    process.stdin.on("end", () => {
        const tmp = path.join(os.tmpdir(), `hephaiste-catch-${Date.now()}.txt`);
        fs.writeFileSync(tmp, data, "utf8");

        exec(`less ${tmp}`, (err) => {
            if (err) console.error("Less exited:", err);
            fs.unlinkSync(tmp);
        });
    });
};

