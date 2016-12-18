// Generated by CoffeeScript 1.11.1
(function() {
  var data, group, i;

  data = $("#metricData")[0].value;

  data = JSON.parse(data);

  group = [];

  i = 0;

  data.forEach(function(d) {
    group.forEach(function(item) {
      if (item === d.group) {
        return i++;
      }
    });
    if (!i) {
      group.push(d.group);
    }
    return i = 0;
  });

  group.forEach(function(item) {
    $("ul.dropdown-menu").append('<li><a id="' + item + '">' + item + '</a></li>');
    return $("#" + item).click(function() {
      return $("#group").val(item);
    });
  });

  $('#datetimepicker').datetimepicker({
    format: 'yyyy-mm-dd hh:ii UTC'
  });

  $("#metric-add-form-show").click(function() {
    $("#metric-add-form").show();
    $("#metric-add-form-show").hide();
    return $("#metric-add-form-hide").show();
  });

  $("#metric-add-form-hide").click(function() {
    $("#metric-add-form").hide();
    $("#metric-add-form-show").show();
    return $("#metric-add-form-hide").hide();
  });

}).call(this);
