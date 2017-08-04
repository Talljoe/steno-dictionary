require! {
  'prelude-ls': { map, unique-by, reject, filter, flatten }
  set: Set
  './common': { read-meta, write-meta, print-duplicates }
}

meta = read-meta!

all-outlines = new Set(meta |> (map  ({strokes}) -> strokes |> map (.stroke)) |> flatten)

sanitize = (stroke) ->
  return that if stroke is \TPHR-RB

  new-stroke = stroke
    |> (.split '/')
    |> reject (is) \TPHR-RB
    |> (.join '/')

  if new-stroke is stroke then stroke
  else if all-outlines.contains new-stroke then null
  else new-stroke

cleanup = (item) ->
  {}
    <<< item
    <<< strokes: item.strokes
      |> map (entry) -> {} <<< entry <<< { stroke: entry.stroke |> sanitize }
      |> filter (.stroke?)
      |> unique-by (.stroke)

meta
  |> map cleanup
  |> print-duplicates
  |> write-meta
