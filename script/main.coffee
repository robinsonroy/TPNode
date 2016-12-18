data = $("#metricData")[0].value
data = JSON.parse( data )

# Find all group of the user
group = []
i = 0
data.forEach( (d) ->
  group.forEach( (item) ->
    i++ if item == d.group
  )
  group.push(d.group) if !i
  i = 0
)
## Fill dropdown and put event click on each element to select the good group
group.forEach( (item)->
  $("ul.dropdown-menu").append('<li><a class="' + item + '">' + item + '</a></li>')

  $("."+item).click( ()->
    console.log "test"
    $("#group").val(item)
    $("#updateGroup").val(item)
    $("#submitUpdateGroup").text("Modify " + item + "\'s values")
  )
)

$('#datetimepicker').datetimepicker({
    format: 'yyyy-mm-dd hh:ii UTC'
});

## SHOW OR HIDE BUTTOM / FORM
$("#metric-add-form-show").click () ->
  $("#metric-add-form").show()
  $("#metric-add-form-show").hide()
  $("#metric-add-form-hide").show()
$("#metric-add-form-hide").click () ->
  $("#metric-add-form").hide()
  $("#metric-add-form-show").show()
  $("#metric-add-form-hide").hide()

$("#metric-update-form-show").click () ->
  $("#metric-update-form").show()
  $("#metric-update-form-show").hide()
  $("#metric-update-form-hide").show()
$("#metric-update-form-hide").click () ->
  $("#metric-update-form").hide()
  $("#metric-update-form-show").show()
  $("#metric-update-form-hide").hide()
