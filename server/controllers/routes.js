// Generated by CoffeeScript 1.7.1
var bookmarks;

bookmarks = require('./bookmarks');

module.exports = {
  'bookmarks': {
    get: bookmarks.all,
    post: bookmarks.create
  },
  'bookmarks/:id': {
    "delete": bookmarks.destroy,
    put: bookmarks.update
  },
  'export': {
    get: bookmarks["export"]
  }
};
