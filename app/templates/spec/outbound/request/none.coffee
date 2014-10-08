<%
var url = require('url');
var querystring = require('querystring');

// include the lead data
var expectedQuery = {};
for (key in normalizedVars.lead) {
  expectedQuery[key] = normalizedVars.lead[key] != null ? normalizedVars.lead[key].toString() : void 0;
}

if (auth == 'key') {
  expectedQuery.apikey  = vars[serviceKey].apikey;
}

// encode the query string
expectedQuery = querystring.encode(expectedQuery);
var expectedUrl = url.parse(request.url);
expectedUrl.search = expectedQuery;
if (expectedUrl.pathname === '/' && !request.url.match(/\/$/))
  expectedUrl.pathname = null;
expectedUrl = url.format(expectedUrl);
%>
it 'should have correct URL', ->
  assert.equal outbound.request(@vars).url, '<%= expectedUrl %>'