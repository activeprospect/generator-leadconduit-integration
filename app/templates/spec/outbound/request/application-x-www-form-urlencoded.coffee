<%
var expectedBody = {};
var value;
for (key in normalizedVars) {
  value = normalizedVars[key];
  expectedBody[key] = value != null ? value.toString() : void 0;
}
expectedBody = require("querystring").encode(expectedBody);
%>
it 'should have URL-encoded body', ->
  expectedBody = '<%= expectedBody %>'
  assert.equal outbound.request(@vars).body, expectedBody