require! {
  'prelude-ls': { map, sort-by, filter, each, reverse, group-by, Obj }
  fs
  './common': { read-meta }
}


read-meta!
  |> map -> name: it.entry, count: it.strokes.length
  |> filter -> it.count > 4
  |> sort-by (.count)
  |> reverse
  |> each -> console.log "#{it.name}: #{it.count}"