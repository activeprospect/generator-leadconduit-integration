<%
var url = request.url;
if (auth == 'key') {
  if (url.indexOf('?') == -1) {
    url = url + '?';
  }
  url = url + 'apikey=#{vars.' + serviceKey + '?.apikey}'
  url = '"' + url + '"';
} else {
  url = "'" + url + "'";
}
%>
request = (vars) ->

  lead = {}

  # Prepare the lead data for submission by using the toString() function on each value. This ensures that
  # complex data types such as phone numbers or postal codes are provided to the service in a normalized format.
  for key, value of vars.lead
    lead[key] = value?.toString()

  # Prepare the body as XML document
  builder = xmlbuilder.create('lead')
  for key, value of lead
    builder.ele(key, value)
  body = builder.end(pretty: true)

  # Return the request
  url:    <%= url %>
  method: '<%= request.method %>'
  headers:
    'Accept':         '<%= response.contentType %>'
    'Content-Type':   '<%= request.contentType %>'
    'Content-Length': body.length <% if (auth == 'basic') { %>
    'Authorization': "Basic #{new Buffer("#{vars.<%=serviceKey%>?.username}:#{vars.<%=serviceKey%>?.password}").toString('base64')}"<% } %>
  body: body