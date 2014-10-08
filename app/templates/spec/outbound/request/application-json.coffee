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
%>
it 'should have correct URL', ->
  assert.equal outbound.request(@vars).url, '<%= expectedUrl %>'

it 'should encode body as JSON', ->
  expectedBody = """
  <%= JSON.stringify(normalizedVars.lead, null, 2).split('\n').join('\n  ') %>
  """
  assert.equal outbound.request(@vars).body, expectedBody