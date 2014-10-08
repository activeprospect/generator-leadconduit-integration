assert = require('chai').assert
fields = require 'leadconduit-fields'
outbound = require '../src/outbound'
<%= integration.spec.requires %>

describe 'Outbound', ->

  describe 'request', ->

    beforeEach ->
      @vars = <% Object.keys(vars).filter(function(name) { return name !== 'lead' }).forEach(function(key) { %>
        <%= key %>: <% Object.keys(vars[key]).forEach(function(name) {%>
          <%= name %>: '<%= vars[key][name] %>' <% })}) %>
        lead: fields.buildLeadVars <% Object.keys(vars.lead).forEach(function(name) { %>
          <%= name %>: '<%= vars.lead[name] %>' <% }) %>

    it 'should be a <%= request.method %>', ->
      assert.equal outbound.request(@vars).method, '<%= request.method %>'

    it 'should accept <%= request.contentType %>', ->
      assert.equal outbound.request(@vars).headers.Accept, '<%= response.contentType %>'
  <% if (request.contentType) { %>
    it 'should have <%= request.contentType %> content type', ->
      assert.equal outbound.request(@vars).headers['Content-Type'], '<%= request.contentType %>'

    it 'should have content length header that matches body length', ->
      req = outbound.request(@vars)
      assert.equal req.headers['Content-Length'], req.body.length
  <% } %><% if (auth == 'basic') {%>
    it 'should have basic auth header', ->
      assert.equal outbound.request(@vars).headers['Authorization'], '<%= basicAuthHeader %>'
  <% } %><%= integration.spec.request %>


    describe 'variables', ->

      for variable in outbound.request.variables()
        do (variable) ->
          if variable.name.match(/^lead\./)
            it "#{variable.name} should be a standard field", ->
              assert fields.isStandard(variable.name), "The #{variable.name} variable is not available as a standard field"


  describe 'response', ->

    beforeEach ->
      @vars = <% Object.keys(vars).filter(function(name) { return name !== 'lead' }).forEach(function(key) { %>
        <%= key %>: <% Object.keys(vars[key]).forEach(function(name) {%>
          <%= name %>: '<%= vars[key][name] %>' <% })}) %>
        lead: fields.buildLeadVars <% Object.keys(vars.lead).forEach(function(name) { %>
          <%= name %>: '<%= vars.lead[name] %>' <% }) %>
      @req = outbound.request(@vars)

    it 'should parse success', ->
      res = outbound.response(@vars, @req, response(outcome: 'success'))
      assert.equal res.outcome, 'success'

    it 'should parse failure', ->
      res = outbound.response(@vars, @req, response(outcome: 'failure', reason: 'something bad happened'))
      assert.equal res.outcome, 'failure'
      assert.equal res.reason, 'something bad happened'

    it 'should parse error', ->
      res = outbound.response(@vars, @req, response(outcome: 'error', reason: 'source not found'))
      assert.equal res.outcome, 'error'
      assert.equal res.reason, 'source not found'

    it 'should treat unsupported outcome as an error', ->
      res = outbound.response(@vars, @req, response(outcome: 'donkey', reason: 'source not found'))
      assert.equal res.outcome, 'error'
      assert.equal res.reason, 'cannot parse response'

<%= integration.spec.response %>