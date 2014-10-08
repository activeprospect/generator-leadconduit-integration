request = (vars) ->

  lead = {}<% if (auth == 'key') {%>

  # Set the API key
  lead.apikey = vars.<%=serviceKey%>?.apikey<% } %>

  # Prepare the lead data for submission by using the toString() function on each value. This ensures that
  # complex data types such as phone numbers or postal codes are provided to the service in a normalized format.
  for key, value of vars.lead
    lead[key] = value?.toString()

  # Prepare the URL encoded body
  body = querystring.encode(lead)

  # Return the request
  url:    '<%= request.url %>'
  method: '<%= request.method %>'
  headers:
    'Accept':         '<%= response.contentType %>'
    'Content-Type':   '<%= request.contentType %>'
    'Content-Length': body.length<% if (auth == 'basic') { %>
    'Authorization':  "Basic #{new Buffer("#{vars.<%=serviceKey%>?.username}:#{vars.<%=serviceKey%>?.password}").toString('base64')}"<% } %>
  body: body