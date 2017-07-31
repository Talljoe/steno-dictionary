main = require "../dictionaries/main.json"

require! {
  'prelude-ls': { obj-to-pairs, group-by, map, head, last, Obj, values, sort-by }
  './common': { write-meta }
}

main
  |> obj-to-pairs
  |> map ([stroke, result]) -> { stroke: stroke, result: result.trim! }
  |> group-by (.result)
  |> Obj.map (entries) ->
    entry: entries[0].result
    description: ''
    categories: []
    strokes: entries
      |> map (.stroke)
      |> map -> { stroke: it, type: '' }
  |> values
  |> sort-by (.entry)
  |> write-meta
