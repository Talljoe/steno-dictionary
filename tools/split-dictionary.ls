require! {
  'prelude-ls': { map, each, Obj, flatten, fold, obj-to-pairs, group-by, keys, first, sort-by, compact }
  fs
  path
  mkdirp
  './common': { write-dictionary, read-meta }
}

meta = read-meta!

explode-strokes = (item) ->
  item.strokes |> map ({stroke}) -> "#stroke": item.entry

process-dictionary = ({category, items}, split = true) ->
  dictionary-path = path.join.apply(null, compact [ \.. \dictionaries if split then \split ])
  console.log "Writing '#{category}' with #{items.length} entries."
  mkdirp.sync dictionary-path
  items
    |> map explode-strokes
    |> flatten
    |> sort-by -> it |> keys |> first
    |> fold (<<<), {}
    |> write-dictionary path.join(dictionary-path, "#{category}.json")

entries = meta
  |> map (item) ->
    switch
    | item.categories.length is 0 => [category: \uncategorized, item: item]
    | otherwise => item.categories |> map (category) -> {category: category, item: item}
  |> flatten
  |> group-by (.category)
  |> Obj.map (map (.item)) # category -> [ item1...itemn ]
  |> obj-to-pairs
  |> map ([category, items]) -> { category, items }
  |> each process-dictionary

process-dictionary { category: \main, items: meta }, false