
module.exports = function greet(args) {
    const nameIndex = args.indexOf("--name");
    const name = nameIndex !== -1 ? args[nameIndex + 1] : "friend";
    console.log(`Forge greets you, ${name}.`);
};

