// Generated by CoffeeScript 1.7.1
var americano;

americano = require('americano');

module.exports = {
  bookmark: {
    byDate: function(doc) {
      return emit(Date.parse(doc.created), doc);
    },
    tags: function(doc) {
      var tag, _i, _len, _ref, _results;
      if ((doc != null) && (doc._id != null) && doc.tags.length) {
        _ref = doc.tags;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tag = _ref[_i];
          _results.push(emit(doc._id, {
            tag: tag
          }));
        }
        return _results;
      }
    }
  }
};
