// Generated by CoffeeScript 1.11.1
(function() {
  var area, data, graph, group, height, i, margin, width, x, xAxis, y, yAxis;

  data = document.getElementById("metricData").value;

  data = JSON.parse(data);

  data.sort(function(a, b) {
    return parseFloat(a.timestamp) - parseFloat(b.timestamp);
  });

  margin = {
    top: 20,
    right: 20,
    bottom: 30,
    left: 50
  };

  width = 960 - margin.left - margin.right;

  height = 500 - margin.top - margin.bottom;

  x = d3.time.scale().range([0, width]);

  y = d3.scale.linear().range([height, 0]);

  xAxis = d3.svg.axis().scale(x).orient("bottom");

  yAxis = d3.svg.axis().scale(y).orient("left");

  area = d3.svg.area().x(function(d) {
    return x(d.timestamp);
  }).y0(height).y1(function(d) {
    return y(d.value);
  });

  graph = function(data, group) {
    var svg;
    svg = d3.select("body").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    data.forEach(function(d) {
      var timestamp;
      timestamp = parseInt(d.timestamp);
      d.timestamp = new Date(timestamp * 1000);
      return d.value = +d.value;
    });
    x.domain(d3.extent(data, function(d) {
      return d.timestamp;
    }));
    y.domain([
      0, d3.max(data, function(d) {
        return d.value;
      })
    ]);
    svg.append("path").datum(data).attr("class", "area").attr("d", area);
    svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis);
    svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text("Value");
    return svg.append("text").attr("x", width / 2).attr("y", 0).attr("text-anchor", "middle").style("font-size", "20px").style("text-decoration", "underline").text(group);
  };

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

  group.forEach(function(g) {
    var dataSet;
    dataSet = [];
    data.forEach(function(d) {
      if (d.group === g) {
        return dataSet.push(d);
      }
    });
    return graph(dataSet, g);
  });

}).call(this);
