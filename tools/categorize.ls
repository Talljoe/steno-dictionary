require! {
  'prelude-ls': { map, unique, difference }
  fs
  './common': { read-meta, write-meta, load-word-lists }
  set: Set
}

words = new Set(load-word-lists!)

special-case =
  "U.S.S. Nimitz": \proper-noun

classifiers =
  * predicate: words~contains
    category: \main
  * predicate: /^['$]?[0-9][0-9,/.:]*(s|st|th|nd|rd)?$/
    category: \number
  * predicate: /^{&[0-9]}$/
    category: \number
  * predicate: /^{\^:?[0-9]+}$/
    category: \number
  * predicate: /^{\^:}[0-9]+$/
    category: \number
  * predicate: /^{>}(?:{&[a-z]})+$/
    category: \fingerspelling
  * predicate: /^{&[A-Z]}$/
    category: \fingerspelling
  * predicate: /^(?:{\W+}|\W+)$/
    category: \punctuation
  * predicate: /^#\w{2,}$/
    category: \hashtag
  * predicate: /^(?:[A-Z]\.?){2,}$/
    category: \abbreviation
  * predicate: /^(the )?[A-Z]\w+/
    category: \proper-noun
  * predicate: /^##[^#]+##$/
    category: \transcription
  * predicate: /^\([^)]+\)$/
    category: \transcription
  * predicate: /\s/
    category: \multi-word

categorize = (item) ->
  add-category = (category) ->
    categories = item.categories
    item <<< categories: item.categories ++ category |> unique

  if item.categories.length == 0
    if special-case[item.entry]? then return add-category that
    for classifier in classifiers
      predicate =
        | classifier.predicate instanceof RegExp => classifier.predicate~test
        | otherwise => classifier.predicate
      if predicate item.entry
        return add-category classifier.category

  item

read-meta!
  |> map categorize
  |> write-meta