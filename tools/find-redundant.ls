require! {
  'prelude-ls': { last, first, compact, flatten, reject, filter, map }
  set: Set
  fs
  './common': { read-meta,  }
}

main = require "../dictionaries/main.json"
meta = read-meta!

input = meta
  |> map (item) ->
    item.strokes |> map (outline) ->
      entry: item.entry,
      outline: outline.stroke
      parts: outline.stroke.split '/'
  |> flatten
  |> reject (.parts.length <= 1)

report = (predicate, formatter) ->
  input
    |> filter predicate
    |> map formatter
    |> (.join "\n")

fs.writeFileSync \redundant-initial.txt, report do
  ({ parts, entry }) -> main[first parts] is entry
  -> "#{it.outline} = #{first it.parts} = #{it.entry}"

fs.writeFileSync \redundant-terminus.txt, report do
  ({ parts, entry }) -> main[last parts] is entry
  ->
    initial-part = first it.parts
    initial-definition = main[initial-part]

    output = "#{it.outline} = #{last it.parts} = #{it.entry}"
    if initial-definition? and initial-definition is not it.entry
      output + "\n >> #{initial-part} = #{initial-definition}"
    else output

fs.writeFileSync \redundant-group.txt, report do
  ({ parts, entry }) -> (parts |> map (-> main[it]) |> (.join ' ')) is entry
  ({ entry, parts, outline }) ->
    pieces = parts |> map -> "(#{it} = #{main[it]})"
    "#{entry} (#{outline}) = " + pieces.join(" + ")