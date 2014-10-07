<% Object.keys(integration.spec.dependencies).map(function(name) { %><%= name.replace(/[^a-z0-9_]+/g, '') %> = require '<%= name %>'
<% }) %>