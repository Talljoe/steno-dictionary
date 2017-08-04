require! <[ fs path js-yaml pythonlike-json-tool ]>
require! {
  'prelude-ls': { lines }
}

write-dictionary = (file, data) -->
  fs.write-file-sync file, (pythonlike-json-tool(data).replace(/^[ \t]+/gm, '') + '\n')

wordlist-path = path.join.apply(null, <[ .. wordlist scowl-2017.01.22 final ]>)

read-word-list = (file) ->
  full-path = path.join(wordlist-path, file)
  if fs.existsSync full-path
    fs.read-file-sync full-path, { encoding: \utf8 } |> lines
  else
    []

to-yaml = (data) -> js-yaml.safeDump data, { noRefs: true }
export
  read-meta: -> js-yaml.safeLoad fs.read-file-sync('../dictionaries/main-meta.yaml')
  write-meta: (data) -> fs.write-file-sync '../dictionaries/main-meta.yaml', to-yaml(data)
  write-dictionary: write-dictionary
  load-word-lists: ({ categories = <[ english american british canadian ]>, sub-categories = <[ words contractions upper ]>, max-size = 70 } = {}) ->
    sizes = [ 10 20 35 40 50 55 60 70 80 95 ]
    [line for category in categories
          for sub-category in sub-categories
          for size in sizes
          for line in read-word-list "#{category}-#{sub-category}.#{size}"
          when size <= max-size]