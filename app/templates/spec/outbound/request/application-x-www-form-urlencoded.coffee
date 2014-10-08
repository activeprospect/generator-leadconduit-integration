<%
var expectedBody = {};
var value;

if (auth == 'key') {
  expectedBody.apikey  = vars[serviceKey].apikey;
}

// include lead data
for (key in normalizedVars.lead) {
  value = normalizedVars.lead[key];
  expectedBody[key] = value != null ? value.toString() : void 0;
}

expectedBody = require("querystring").encode(expectedBody);
%>
it 'should have correct URL', ->
  assert.equal outbound.request(@vars).url, '<%= request.url %>'

it 'should have URL-encoded body', ->
  expectedBody = '<%= expectedBody %>'
  assert.equal outbound.request(@vars).body, expectedBody