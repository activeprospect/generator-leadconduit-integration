response = (vars, req, res) ->

  appendData =
    if res.status % 200 < 100
      # The response status is in the 200 range

      # Parse the body as JSON
      doc = mimecontent(res.body, 'text/xml')

      # Assume that the object returned has outcome and reason properties
      outcome = doc.xpath('//outcome/text()')?.toString()?.toLowerCase()
      reason = doc.xpath('//reason/text()').toString()

      # The only valid outcomes are 'success', 'failure' and 'error'
      if ['success', 'failure', 'error'].indexOf(outcome) != -1
        outcome: outcome
        reason: reason
      else
        outcome: 'error'
        reason: 'cannot parse response'
    else
      # The response status is NOT in the 200 range. Treat this as an error.
      outcome: 'error'
      reason: res.body

  # Return the data to append
  appendData
