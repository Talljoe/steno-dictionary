require! {
  'prelude-ls': { map, unique, difference }
  fs
  './common': { read-meta, write-meta }
}

categorize = (item) ->
  add-category = (category) ->
    categories = item.categories
    item <<< categories: item.categories ++ category |> unique

  # remove auto-generated categories - this is debatable as perhaps we want to manually add a category
  item.categories = difference item.categories, <[ number fingerspelling ]>

  switch
    | item.entry is /^(?:[0-9][0-9,.]*|{&[0-9]})$/ => add-category \number
    | item.entry is /^(?:{>}(?:{&[a-z]})+|{&[A-Z]})$/ => add-category \fingerspelling
    | otherwise => item

read-meta!
  |> map categorize
  |> write-meta