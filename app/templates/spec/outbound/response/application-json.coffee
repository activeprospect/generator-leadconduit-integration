response = (body={}) ->
  status: 201
  headers:
    'Content-Type': 'application/json'
  body: JSON.stringify(body)