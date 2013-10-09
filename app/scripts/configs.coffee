app.service 'Configs', [ () ->
  step = []

  @set_step = (index, todo) -> step[index] = todo

  @get_step = (index) -> step[index] 

]