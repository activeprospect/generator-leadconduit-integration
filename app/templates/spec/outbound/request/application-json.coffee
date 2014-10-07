
it 'should encode body as JSON', ->
  expectedBody = """
  <%= JSON.stringify(normalizedVars, null, 2).split('\n').join('\n  ') %>
  """
  assert.equal outbound.request(@vars).body, expectedBody