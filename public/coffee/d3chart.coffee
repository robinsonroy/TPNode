
data = document.getElementById("metricData").value
data = JSON.parse( data )

data.sort(  (a, b) ->
    parseFloat(a.timestamp) - parseFloat(b.timestamp);
)

margin = {top: 20, right: 20, bottom: 30, left: 50}
width = 960 - margin.left - margin.right
height = 500 - margin.top - margin.bottom

x = d3.time.scale().range([0, width])
y = d3.scale.linear().range([height, 0])

xAxis = d3.svg.axis().scale(x).orient("bottom")
yAxis = d3.svg.axis().scale(y).orient("left")

area = d3.svg.area()
  .x((d) ->
    x(d.timestamp)
    )
  .y0(height)
  .y1((d) ->
    y(d.value)
    )

graph = (data, group) ->
  svg = d3.select("body").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

  data.forEach( (d)->
    timestamp = parseInt(d.timestamp)
    d.timestamp = new Date(timestamp * 1000)
    d.value = +d.value
  )

  x.domain(d3.extent(data, (d) -> d.timestamp ))
  y.domain([0, d3.max(data, (d) -> d.value )])

  svg.append("path")
      .datum(data)
      .attr("class", "area")
      .attr("d", area)

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Value")

  svg.append("text")
        .attr("x", (width / 2))
        .attr("y", 0)
        .attr("text-anchor", "middle")
        .style("font-size", "20px")
        .style("text-decoration", "underline")
        .text(group);


group = []
i = 0

data.forEach( (d) ->
  group.forEach( (item) ->
    i++ if item == d.group
  )
  group.push(d.group) if !i
  i = 0
)

group.forEach( (g)->
  dataSet = []
  data.forEach( (d) ->
    dataSet.push(d) if d.group == g
  )
  graph(dataSet, g)
)
