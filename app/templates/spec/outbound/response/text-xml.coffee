<%
var xml = require('xmlbuilder').create('lead');
var key;
for (key in normalizedVars) {
xml.ele(key, normalizedVars[key]);
}
xml = xml.end({pretty: true}).split('\n').join('\n  ');
%>
response = (result={}) ->
  status: 201
  headers:
    'Content-Type': 'text/xml'
  body: """
  <?xml version="1.0"?>
  <result>
    <outcome>#{result.outcome}</outcome>
    <reason>#{result.reason}</reason>
  </result>
  """