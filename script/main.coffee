data = $("#metricData")[0].value
data = JSON.parse( data )

group = []
i = 0

data.forEach( (d) ->
  group.forEach( (item) ->
    i++ if item == d.group
  )
  group.push(d.group) if !i
  i = 0
)

group.forEach( (item)->
  $("ul.dropdown-menu").append('<li><a id="' + item + '">' + item + '</a></li>')

  $("#"+item).click( ()->
    $("#group").val(item)
  )
)

$('#datetimepicker').datetimepicker({
    format: 'yyyy-mm-dd hh:ii UTC'
});


$("#metric-add-form-show").click () ->
  $("#metric-add-form").show()
  $("#metric-add-form-show").hide()
  $("#metric-add-form-hide").show()
$("#metric-add-form-hide").click () ->
  $("#metric-add-form").hide()
  $("#metric-add-form-show").show()
  $("#metric-add-form-hide").hide()
