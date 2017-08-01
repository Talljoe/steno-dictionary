require! {
  'prelude-ls': { map, sort-by, filter, each, reverse, group-by, Obj, flatten, sum, unique }
  fs
  './common': { read-meta }
}


meta = read-meta!

meta
  |> map -> name: it.entry, count: it.strokes.length
  |> filter -> it.count > 4
  |> sort-by (.count)
  |> reverse
  |> each -> console.log "#{it.name}: #{it.count}"

total-strokes = meta
  |> map -> it.strokes |> map ({stroke}) -> stroke.split('/')
  |> flatten
  |> unique
  |> (.length)

console.log "Total unique strokes: #{total-strokes}"
