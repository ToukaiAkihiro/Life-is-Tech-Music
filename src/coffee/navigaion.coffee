$headings =
  year: $ "#main h2"
  camp: $ "#main h3"

$scroller = $ "html, body"

$container = $ "#navigations"

timeout = null

html = ""

for $h, i in $ "#main h2, #main h3"
  if $h.tagName is "H2"
    if i isnt 0
      html +="  </ul>\n</li>\n"
    t = $h.innerText
    tn = parseInt t
    html += """
    <li class="year" data-year="#{
      unless isNaN tn
        "'#{tn.toString().slice -2}"
      else
        ""
      }">
      <div class="inneryear">#{t}</div>
      <ul class="outerCamp">\n
    """
  else if $h.tagName is "H3"
    html += "    <li class='camp'>#{$h.innerText}</li>\n"

html += "  </ul>\n</li>"

$container.html html
.on "mouseenter", ".year", ->
  $this = $ this
  w = do $this
    .children ".inneryear"
    .innerWidth

  $this.css width: w
    .addClass "opened"
.on "mouseleave", ".year", ->
  $ this
  .css width: 0
  .removeClass "opened"
.on "mouseenter", ".inneryear, .outerCamp", ->
  timeout? and clearTimeout timeout
  $outer = $(this).closest ".year"
  $outerCamp = $outer.children ".outerCamp"
  $lastCamp = $outerCamp.children ":last"
  height = $lastCamp.position().top + do $lastCamp.innerHeight

  $outer.css width: do $outerCamp.innerWidth
  t = $outer.css "transition-duration"
  
  timeout = setTimeout ->
    $outerCamp.css
      visibility: "visible"
      height: height
      paddingTop: "1.5em"
  , parseFloat(t) * 1000

.on "click", "li", ->
  target = if this.classList.contains "year" then "year" else "camp"
  index = $container.find "li.#{target}"
  .index this
  top = $headings[target]
  .eq index
  .offset()
  .top
  $scroller.animate scrollTop: top, 200
  no
