request = (vars) ->

  lead = {}<% if (auth == 'key') {%>

  # Set the API key
  lead.apikey = vars.<%=serviceKey%>?.apikey<% } %>

  # Prepare the lead data for submission by using the toString() function on each value. This ensures that
  # complex data types such as phone numbers or postal codes are provided to the service in a normalized format.
  for key, value of vars.lead
    lead[key] = value?.toString()

  # Parse the URL, so it can be reconstituted later with the lead data
  parsedUrl = url.parse('<%= request.url %>', true)

  # If there is a query portion of the request URL, then merge it in to the lead data so it doesn't get lost.
  if parsedUrl.query?
    for key, value of parsedUrl.query
      lead[key] = value

  # Now include the original query and the lead data all in the URL
  parsedUrl.search = querystring.encode(lead)
  <% if (require('url').parse(request.url).pathname == '/' && !request.url.match(/\/$/)) { %>
  # Original URL had no trailing slash, so remove it from the parsedUrl
  parsedUrl.pathname = null
  <% } %>
  # Stringify the URL object
  formattedUrl = url.format(parsedUrl)

  # Return the request
  url: formattedUrl
  method: '<%= request.method %>'
  headers:
    Accept: '<%= response.contentType %>'
    <% if (auth == 'basic') { %>'Authorization': "Basic #{new Buffer("#{vars.<%=serviceKey%>?.username}:#{vars.<%=serviceKey%>?.password}").toString('base64')}"<% } %>