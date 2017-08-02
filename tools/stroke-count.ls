require! {
  'prelude-ls': { map, sort-by, filter, each, reverse, group-by, Obj, flatten, sum, unique }
  fs
  './common': { read-meta }
}


meta = read-meta!

meta
  |> map ({ entry, strokes}) ->
    stroke-list = strokes |> map (.stroke)
    return
      name: entry
      strokes: stroke-list
      count: stroke-list.length
  |> filter ({count}) -> count > 10
  |> sort-by (.count)
  |> reverse
  |> each ({ name, count }) ->
    console.log "#{name}: #{count}"

all-strokes = meta
  |> map ({strokes}) ->
    strokes |> map ({stroke}) -> stroke.split('/')
  |> flatten
console.log "Total strokes: #{all-strokes.length}"

unique-strokes = all-strokes |> unique
console.log "Unique strokes: #{unique-strokes.length}"
# fs.write-file-sync 'unique.txt', unique-strokes.sort().join('\n')
