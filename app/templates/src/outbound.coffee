<%= integration.src.requires %>

#
# Request Function -------------------------------------------------------
#

#
# Create the request that will be posted to the outbound service endpoint.
#
# vars - an object containing the original lead data (under `vars.lead`), and
#        all appended data (under other `vars` keys as appropriate)
#
# Returns a request object with the url, method, headers, and body properties.
#
<%= integration.src.request %>


#
# Retrieve the variables required by the request() function.
#
# Returns an Array of variables objects, each with name, description and boolean required flag.
#
request.variables = ->
  [ <% fields.map(function(field) { %>
    { name: 'lead.<%= field.id %>', type: '<%= field.type %>', description: '<%= field.description  %>' } <% }) %>
  ]


#
# Response Function ------------------------------------------------------
#

#
# This function parses the response returned by the outbound service endpoint.
# Its input is the response object that includes:
#  * status  - numeric HTTP status (e.g., 200, 404, 500)
#  * headers - an object with HTTP header options
#  * body    - a string with the response body
#
<%= integration.src.response %>


#
# The response variables function must return an Array that defines all the fields that this integration
# appends to the lead after the integration completes. The 'outcome' and 'reason' are standard and always required.
#
response.variables = ->
  [
    { name: 'outcome', type: 'string', description: 'Integration outcome (success, failure, or error)' },
    { name: 'reason', type: 'string', description: 'If outcome is error, the error reason' }
  ]



#
# Exports ----------------------------------------------------------------
#

#
# Your integration module must export the request and response function.
#
module.exports =
  request: request
  response: response