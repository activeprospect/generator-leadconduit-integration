var npm = require('npm');
var async = require('async');

module.exports = function(moduleNames, callback) {
  var getVersion = function(moduleName, done) {
    npm.commands.view([moduleName, 'version'], true, function(err, version) {
      if (err) return done(err);
      done(null, Object.keys(version)[0]);
    });
  };
  npm.load({}, function (err) {
    if (err) return callback(err);
    async.map(moduleNames, getVersion, function(err, versions) {
      if (err) return callback(err);
      var dependencies = {};
      moduleNames.reduce(function(obj, name, index) {
        try {
          if (require.resolve(name) === name)
            obj[name] = null;
          else
            // not a core module
            if (versions[index])
              obj[name] = '^' + versions[index];
        } catch (err) {
          // not a core module
          if (versions[index])
            obj[name] = '^' + versions[index];
        }
        return obj;
      }, dependencies);
      callback(null, dependencies);
    });
  });
};