<%
var url = require('url');
var querystring = require('querystring');
var expectedQuery = {};
for (key in normalizedVars) {
  expectedQuery[key] = normalizedVars[key] != null ? normalizedVars[key].toString() : void 0;
}
expectedQuery = querystring.encode(expectedQuery);
var expectedUrl = url.parse(request.url);
expectedUrl.search = expectedQuery;
if (expectedUrl.pathname === '/' && !request.url.match(/\/$/))
  expectedUrl.pathname = null;
expectedUrl = url.format(expectedUrl);
%>
it 'should have correct URL', ->
  assert.equal outbound.request(@vars).url, '<%= expectedUrl %>'