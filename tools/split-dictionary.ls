require! {
  'prelude-ls': { map, each, Obj, flatten, fold, obj-to-pairs, group-by, keys, first, sort-by }
  fs
  './common': { write-dictionary, read-meta }
}

meta = read-meta!

explode-strokes = (item) ->
  item.strokes |> map ({stroke}) -> "#stroke": item.entry

process-dictionary = ([category, items]) ->
  console.log "Writing '#{category}' with #{items.length} entries."
  items
    |> map explode-strokes
    |> flatten
    |> sort-by -> it |> keys |> first
    |> fold (<<<), {}
    |> write-dictionary "../dictionaries/split/#{category}.json"

meta
  |> map (item) ->
    switch
    | item.categories.length is 0 => [category: \main, item: item]
    | otherwise => item.categories |> map (category) -> {category: category, item: item}
  |> flatten
  |> group-by (.category)
  |> Obj.map (map (.item)) # category -> [ item1...itemn ]
  |> obj-to-pairs
  |> each process-dictionary
