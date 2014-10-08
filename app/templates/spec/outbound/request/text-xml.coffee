<%
var url = require('url');
var querystring = require('querystring');
var expectedUrl = null;
if (auth == 'key') {
  expectedUrl = url.parse(request.url);
  expectedUrl.search = querystring.encode({ apikey: vars[serviceKey].apikey });
  if (expectedUrl.pathname === '/' && !request.url.match(/\/$/))
    expectedUrl.pathname = null;
  expectedUrl = url.format(expectedUrl);
} else {
  expectedUrl = request.url;
}

var xml = require('xmlbuilder').create('lead');
var key;
for (key in normalizedVars.lead) {
  xml.ele(key, normalizedVars.lead[key]);
}
xml = xml.end({pretty: true}).split('\n').join('\n  ');
%>
it 'should have correct URL', ->
  assert.equal outbound.request(@vars).url, '<%= expectedUrl %>'

it 'should encode body as XML', ->
  expectedBody = '''
  <%= xml %>
  '''
  assert.equal outbound.request(@vars).body, expectedBody