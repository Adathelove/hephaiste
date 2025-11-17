#!/usr/bin/env node

const { Command } = require('commander');
const program = new Command();

program
  .name('hephaiste')
  .description('Forge tools for persona and craft management')
  .version('0.1.0');

program
  .option('--persona-dir <path>', 'Path to persona directory');

program
  .command('greet')
  .description('Greet the forge')
  .option('--name <name>', 'Name to greet')
  .action((options) => {
    const name = options.name || 'friend';
    console.log(`Forge greets you, ${name}.`);
  });

program
  .command('menu')
  .description('Prompt menu')
  .action(() => {
    require('./commands/menu')();
  });

program
  .command('catcher')
  .description('Capture stdin and page it')
  .action(() => {
    require('./commands/catcher')();
  });

program
  .command('list <what>')
  .description('List forge elements')
  .action((what) => {
    const opts = program.opts();
    require('./commands/list')(what, opts);
  });

program.parse(process.argv);

