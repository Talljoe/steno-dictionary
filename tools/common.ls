require! <[ fs js-yaml ]>

write-dictionary = (file, data) -->
  fs.write-file-sync file, JSON.stringify(data, null, 2)

to-yaml = (data) -> js-yaml.safeDump data, { noRefs: true }
export
  read-meta: -> js-yaml.safeLoad fs.read-file-sync('../dictionaries/main-meta.yaml')
  write-meta: (data) -> fs.write-file-sync '../dictionaries/main-meta.yaml', to-yaml(data)
  write-dictionary: write-dictionary