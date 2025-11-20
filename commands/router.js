/**
 * commands/router.js
 * Pure loader for command modules.
 * No logic, no CLI parsing — just exports.
 */

module.exports = {
  greet: require('./greet'),
  menu: require('./menu'),
  catcher: require('./catcher'),
  list: require('./list'),
  inspect: require('./inspect')
};

