main = require "../dictionaries/main.json"

require! {
  'prelude-ls': { obj-to-pairs, group-by, map, head, last, Obj, values, sort-by }
  fs
}

meta = main
  |> obj-to-pairs
  |> group-by (.1)
  |> Obj.map (entries) ->
    entry: entries |> head |> last
    description: ''
    categories: []
    strokes: entries
      |> map (.0)
      |> map -> { stroke: it, type: '' }
  |> values
  |> sort-by (.entry)

err <- fs.write-file '../dictionaries/main-meta.json', JSON.stringify meta
throw err if err?
