#!/usr/bin/env node

const { Command } = require('commander');
const program = new Command();

// Load all command logic from the router
const commands = require('./commands/router');

program
  .name('hephaiste')
  .description('Forge tools for persona and craft management')
  .version('0.1.0');

program
  .option('--persona-dir <path>', 'Path to persona directory');

// --- greet ---
program
  .command('greet')
  .description('Greet the forge')
  .option('--name <name>', 'Name to greet')
  .action((options) => {
    const name = options.name || 'friend';
    commands.greet(name);
  });

// --- menu ---
program
  .command('menu')
  .description('Prompt menu')
  .action(() => {
    commands.menu();
  });

// --- catcher ---
program
  .command('catcher')
  .description('Capture stdin and page it')
  .action(() => {
    commands.catcher();
  });

// --- list ---
program
  .command('list <what>')
  .description('List forge elements')
  .action((what) => {
    const opts = program.opts();
    commands.list(what, opts);
  });

// --- inspect ---
program
  .command('inspect <persona>')
  .description('Inspect a persona settings file and list its components')
  .action((persona) => {
    const opts = program.opts();
    commands.inspect(persona, opts);
  });

program.parse(process.argv);

