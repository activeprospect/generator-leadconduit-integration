<%
var xml = require('xmlbuilder').create('lead');
var key;
for (key in normalizedVars) {
  xml.ele(key, normalizedVars[key]);
}
xml = xml.end({pretty: true}).split('\n').join('\n  ');
%>
it 'should encode body as XML', ->
  expectedBody = '''
  <%= xml %>
  '''
  assert.equal outbound.request(@vars).body, expectedBody