/*global describe, beforeEach, it*/
'use strict';

var path = require('path');
var assert = require('yeoman-generator').assert;
var helpers = require('yeoman-generator').test;
var os = require('os');
var gitparse = require('../app/util');

describe('leadconduit:app', function () {

  it('the generator can be required without throwing', function () {
    this.app = require('../app');
  });

  var options = {
    'skip-install': true,
    'skip-welcome-message': true
  };

  var prompts = {
    continue: true,
    fields: []
  };

  var runGen;

  describe('outbound', function () {

    beforeEach(function () {
      prompts.type = 'outbound';

      runGen = helpers
        .run(path.join(__dirname, '../app'))
        .inDir(path.join(__dirname, './temp-test'))
        .withPrompts(prompts)
        .withGenerators([[helpers.createDummyGenerator(), 'mocha:app']]);
    });

    it('creates files', function (done) {
      runGen.withOptions(options).on('end', function() {
        assert.file([
          '.gitignore',
          '.npmignore',
          '.travis.yml',
          'Cakefile',
          'Readme.md',
          'package.json',
          'spec/outbound-spec.coffee',
          'src/outbound.coffee'
        ]);
        done();
      });
    });
  });

  xdescribe('inbound', function () {

    beforeEach(function () {
      prompts.type = 'inbound';

      runGen = helpers
        .run(path.join(__dirname, '../app'))
        .inDir(path.join(__dirname, './temp-test'))
        .withPrompts(prompts)
        .withGenerators([[helpers.createDummyGenerator(), 'mocha:app']]);
    });

    it('creates files', function (done) {
      runGen.withOptions(options).on('end', function() {
        assert.file([
          '.gitignore',
          '.npmignore',
          '.travis.yml',
          'Cakefile',
          'Readme.md',
          'package.json',
          'spec/inbound-spec.coffee',
          'src/inbound.coffee'
        ]);

        done();
      });
    });

  });
});

describe('gitparse', function () {

  it('should parse git:// urls', function () {
    assert.equal(gitparse('git://github.com/happyuser/nicerepo.git')['user'], 'happyuser');
    assert.equal(gitparse('git://github.com/happyuser/nicerepo.git')['repo'], 'nicerepo');
  });

  it('should parse git@ urls', function () {
    assert.equal(gitparse('git@github.com/happyuser/nicerepo.git')['user'], 'happyuser');
    assert.equal(gitparse('git@github.com/happyuser/nicerepo.git')['repo'], 'nicerepo');
  });

  it('should parse http:// urls', function () {
    assert.equal(gitparse('http://github.com/happyuser/nicerepo.git')['user'], 'happyuser');
    assert.equal(gitparse('http://github.com/happyuser/nicerepo.git')['repo'], 'nicerepo');
  });

  it('should return unknowns when url is empty', function () {
    assert.equal(gitparse('')['user'], 'unknown');
    assert.equal(gitparse('')['repo'], 'unknown');
  });

  it('should return unknowns when url is unrecognized', function () {
    assert.equal(gitparse('http://unrecognizedurlformat.com')['user'], 'unknown');
    assert.equal(gitparse('http://unrecognizedurlformat.com')['repo'], 'unknown');
  });

});