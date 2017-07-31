require! <[ fs ]>

write = (file, data) -->
  fs.write-file-sync file, JSON.stringify(data, null, 2)

export
  read-meta: -> JSON.parse fs.read-file-sync('../dictionaries/main-meta.json')
  write-meta: write '../dictionaries/main-meta.json'
  write-dictionary: write