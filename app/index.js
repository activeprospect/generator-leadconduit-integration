'use strict';
var _ = require('underscore');
var fs = require('fs');
var path = require('path');
var string = require('underscore.string');
var yeoman = require('yeoman-generator');
var yosay = require('yosay');
var async = require('async');
var rimraf = require('rimraf');
var shell = require('shelljs');
var fields = require('leadconduit-fields');
var deps = require('./dependencies');
var vars = require('./vars');


var templateName = function (contentType) {
  if (contentType !== null && contentType !== undefined)
    return contentType.replace(/\//g, '-');
  else
    return 'none';
};

var fieldOptions = [
  'first_name', 'last_name', 'email', 'phone_1', 'phone_2', 'address_1', 'address_2', 'city', 'state', 'postal_code', 'comments'
];

var LeadConduitIntegrationGenerator = yeoman.generators.Base.extend({
  initializing: function () {
    this.pkg = require('../package.json');
  },

  prompting: function () {
    var self = this;
    var done = this.async();

    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to the LeadConduit Integration generator!'
    ));

    var isOutbound = function (answers) {
      return answers.type.indexOf('outbound') !== -1;
    };

    var prompts = [
      {
        type: 'confirm',
        name: 'continue',
        message: 'You haven\'t set up a GitHub repository. Continue anyway?',
        default: false,
        when: function() {
          return !shell.exec('git remote -v', { silent: true }).output.split('\t')[1];
        }
      }
    ];
    this.prompt(prompts, function (answers) {
      if (answers.continue !== undefined && !answers.continue) {
        this.log("For help, see https://help.github.com/articles/create-a-repo/.");
        process.exit(1);
      }

      var prompts = [
        {
          type: 'input',
          name: 'name',
          message: 'What is the name of the service are you integrating with?',
          default: function() {
            var name = self.appname.split(' ').pop();
            var char = name.charAt(0);
            if (char !== char.toUpperCase())
              name = string.capitalize(name);
            return name;
          }
        },
        {
          type: 'list',
          name: 'type',
          message: 'Select integration type:',
          choices: [
            { name: 'Outbound (out of LeadConduit)', value: 'outbound' },
            { name: 'Inbound (into LeadConduit)', value: 'inbound' }
          ]
        },

        // Outbound questions
        {
          type: 'input',
          name: 'url',
          message: 'What is the service\'s URL?',
          default: 'http://mywebservice',
          when: isOutbound
        },
        {
          type: 'list',
          name: 'method',
          message: 'What HTTP method is the service expecting?',
          choices: [
            'POST', 'GET', 'PUT', 'DELETE', 'HEAD'
          ],
          default: 'POST',
          when: isOutbound
        },
        {
          type: 'list',
          name: 'requestContentType',
          message: 'What format (Content-Type) is the service expecting?',
          choices: [
            { name: 'Standard Form POST (application/x-www-form-urlencoded)', value: 'application/x-www-form-urlencoded' },
            { name: 'JSON (application/json)', value: 'application/json' },
            { name: 'XML (text/xml)', value: 'text/xml' }
          ],
          default: 'application/x-www-form-urlencoded',
          when: function (answers) {
            return isOutbound(answers) && (answers.method === 'POST' || answers.method == 'PUT' );
          }
        },
        {
          type: 'list',
          name: 'responseContentType',
          message: 'What format (Content-Type) does the service respond with?',
          choices: [
            { name: 'JSON (application/json)', value: 'application/json' },
            { name: 'XML (text/xml)', value: 'text/xml' },
            { name: 'Plain text (text/plain)', value: 'text/plain' }
          ],
          default: function (answers) {
            if (answers.requestContentType === 'application/x-www-form-urlencoded')
              return 'application/json';
            else
              return answers.requestContentType;
          },
          when: isOutbound
        },
        {
          type: 'input',
          name: 'successString',
          message: 'What string in the response indicates a successful outcome?',
          default: 'success',
          when: function(answers) {
            return isOutbound(answers) && answers.responseContentType === 'text/plain';
          }
        },
        {
          type: 'input',
          name: 'failureString',
          message: 'What string in the response indicates a failed outcome?',
          default: 'failure',
          when: function(answers) {
            return isOutbound(answers) && answers.responseContentType === 'text/plain';
          }
        },
        {
          type: 'checkbox',
          name: 'fields',
          message: 'What of these basic fields should be sent to the service?',
          choices: fieldOptions.map(function(id) {
            var field = _.findWhere(fields, { id: id });
            return { name: field.name, value: field };
          }),
          when: isOutbound
        }
      ];

      this.prompt(prompts, function (answers) {
        this.require = require;
        this.name = answers.name;
        this.serviceKey = string.underscored(this.name.toLowerCase().replace(/[^0-9a-z _]/g, ''));
        this.packageName = 'leadconduit-' + this.serviceKey;
        this.repoName = 'leadconduit-integration-' + this.serviceKey;
        this.type = answers.type;
        this.fields = answers.fields;
        this.vars = vars(answers.fields);
        this.normalizedVars = require('leadconduit-fields').buildLeadVars(this.vars);

        var githubRepoUrl = shell.exec('git remote -v', { silent: true }).output.split('\t')[1];
        this.githubUser = null;
        this.githubRepo = null;
        if (githubRepoUrl) {
          var match = githubRepoUrl.match(/git@github.com:([^/]+)\/([a-z0-9-_.]+).git/i);
          this.githubUser = match[1];
          this.githubRepo = match[2];
        }

        if (this.type == 'outbound') {
          this.request = {
            url: answers.url,
            method: answers.method,
            hasBody: answers.method === 'POST' || answers.method === 'PUT',
            contentType: answers.requestContentType
          };
          this.response = {
            contentType: answers.responseContentType
          };
          if (answers.successString)
            this.successString = answers.successString.toLowerCase();
          if (answers.failureString)
            this.failureString = answers.failureString.toLowerCase();
        }

        var self = this;

        var resolveDependencies = function(dir, callback) {
          var requestFile = templateName(self.request.contentType);
          var responseFile = templateName(self.response.contentType);
          var requirements = [ requestFile, responseFile ];
          var indent = 0;
          if (dir === 'spec') { indent = 4 }
          var depNames = _.uniq(_.flatten(requirements.map(function (file) {
            return require(path.join(self.sourceRoot(), dir, self.type, 'requires', file + '.js'));
          })));
          deps(depNames, function(err, dependencies) {
            if (err) return callback(err);
            self.integration = self.integration || {};
            self.integration[dir] = {};
            self.integration[dir].dependencies = dependencies;
            self.integration[dir].requires = cleanUp(_.template(self.read(path.join(dir, 'requires.coffee')))(self));
            self.integration[dir].request = cleanUp(_.template(self.read(path.join(dir, self.type, 'request', requestFile + '.coffee')))(self), indent);
            self.integration[dir].response = cleanUp(_.template(self.read(path.join(dir, self.type, 'response', responseFile + '.coffee')))(self), indent);
            callback();
          });
        };

        var cleanUp = function(content, indent) {
          var lines = content.split('\n');
          while(lines[0] && lines[0].trim() === '') {
            lines.shift();
          }
          while(lines[lines.length - 1] && lines[lines.length - 1].trim() === '') {
            lines.pop();
          }
          if (indent == null || indent == undefined)
            indent = -1;
          var indentation = Array(indent + 1).join(' ');
          return indentation + lines.join('\n' + indentation);
        };

        var dirs = ['src', 'spec'];
        async.each(dirs, resolveDependencies, function(err) {
          if (err) {
            console.error(err);
            process.exit(1);
          }
          done()
        });
      }.bind(this));
    }.bind(this));

  },

  writing: {
    app: function () {
      this.dest.mkdir('src');
      this.dest.mkdir('spec');
      this.template('package.json', 'package.json');
      this.template('src/' + this.type + '.coffee', 'src/' + this.type + '.coffee');
      this.template('spec/' + this.type + '-spec.coffee', 'spec/' + this.type + '-spec.coffee');
    },

    projectfiles: function () {
      this.template('Readme.md', 'Readme.md');
      this.src.copy('Cakefile', 'Cakefile');
      this.src.copy('travis.yml', '.travis.yml');
      this.src.copy('gitignore', '.gitignore');
      this.src.copy('npmignore', '.npmignore');
      this._removeDir(path.join(this.destinationRoot(), 'node_modules'));
    }
  },

  end: function () {
    this.npmInstall();
  },

  _removeDir: function(dir) {
    var cb = this.async(),
      self = this;
    rimraf(dir, function () {
      self.log.info('Removing dir');
      cb();
    });
  }
});

module.exports = LeadConduitIntegrationGenerator;
