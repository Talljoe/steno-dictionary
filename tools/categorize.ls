require! {
  'prelude-ls': { map, unique, difference }
  fs
  './common': { read-meta, write-meta, load-word-lists }
  set: Set
}

words = new Set(load-word-lists!)
common-words = new Set(load-word-lists max-size: 10)
abbreviations = new Set(load-word-lists sub-categories: <[ abbreviations ]>)

special-case = {}

classifiers =
  * predicate: common-words~contains
    category: \common
  * predicate: words~contains
    category: \main
  * predicate: (entry) -> abbreviations~contains switch
      | entry is /^([A-Z]\.)+$/ => entry.replace(/\./g, '')
      | otherwise => entry
    category: \abbreviation
  * predicate: /^['$]?[0-9][0-9,/.:]*(s|st|th|nd|rd)?$/
    category: \number
  * predicate: /^{&[0-9]}$/
    category: \number
  * predicate: /^{\^:?[0-9]+}$/
    category: \number
  * predicate: /^{\^:}[0-9]+$/
    category: \number
  * predicate: /^{>}(?:{&[a-z]})+$/ # {>}{a}
    category: \fingerspelling
  * predicate: /^{&.+}$/ # {A}
    category: \fingerspelling
  * predicate: /^(?:{\W+}|\W+)$/ # {.}
    category: \punctuation
  * predicate: /^#\w{2,}$/ # #winning
    category: \hashtag
  # * predicate: /^([Tt]he )?[A-Z\-]*[A-Z][a-z']+$/ # the Bible
  #   category: \proper-noun
  * predicate: /^([tT]he )?([A-Z\-]*[A-Z][a-z']+\b\s*(, |of |the |to |and |or |with |al[ \-]|[oi]n |for |la | & |del? |di ?|d'|o'|v\. |at? |und |l[oa]s |es |v[ao]n |\.(com|net|org|[a-z]{2}))*)+$/ # The Great Gatsby
    category: \proper-noun
  * predicate: /^([tT]he )?[A-Z][\w.]*[\s'\-]+[A-Z](?![A-Z])/ # U.S.S. Nimitz, Q-Tip
    category: \proper-noun
  * predicate: /^##[^#]+##$/ # ##ERROR##
    category: \transcription
  * predicate: /^\([^)]+\)$/ # (inaudible)
    category: \transcription
  * predicate: /^{\^?[^}]+\^?}$/ # {^ed}
    category: \word-part
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