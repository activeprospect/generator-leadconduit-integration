response = (vars, req, res) ->
  body = res.body.toLowerCase()

  appendData =
    if body.indexOf('<%= successString %>') != -1
      outcome: 'success'
    else if body.indexOf('<%= failureString %>') != -1
      outcome: 'failure'
    else
      outcome: 'error'

  return appendData