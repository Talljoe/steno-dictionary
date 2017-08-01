require! {
  'prelude-ls': { map, unique, difference }
  fs
  './common': { read-meta, write-meta }
}

categorize = (item) ->
  add-category = (category) ->
    categories = item.categories
    item <<< categories: item.categories ++ category |> unique

  switch
    | item.categories.length > 0 => item # skip if it has a category
    | item.entry is /^(?:\$?[0-9][0-9,.:]*|{&[0-9]}|{\^:?[0-9]+})$/ => add-category \number
    | item.entry is /^(?:{>}(?:{&[a-z]})+|{&[A-Z]})$/ => add-category \fingerspelling
    | item.entry is /^(?:{\W+}|\W+)$/ => add-category \punctuation
    | item.entry is /^#\w{2,}$/ => add-category \hashtag
    | item.entry is /^(?:[A-Z]\.?){2,}$/ => add-category \abbreviation
    | item.entry is /^[A-Z]\w+/ => add-category \proper-noun
    | otherwise => item

read-meta!
  |> map categorize
  |> write-meta