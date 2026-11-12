// Run after Models/Poem.swift in a single Swift script (see verify-model.sh).
let poems = Poem.library
precondition(poems.count == 8)
precondition(Set(poems.map(\.id)).count == poems.count, "Poem IDs must be unique")
precondition(poems.allSatisfy { !$0.title.isEmpty && !$0.author.isEmpty && $0.lines.count == 4 && !$0.note.isEmpty })
let store = ReadingStore()
let original = store.favorites
let poem = poems[0]
let initiallySaved = original.contains(poem.id)
store.toggle(poem)
precondition(store.favorites.contains(poem.id) != initiallySaved)
precondition(ReadingStore().favorites == store.favorites, "Favorites must reload from storage")
store.toggle(poem)
precondition(store.favorites == original, "Second toggle must restore initial state")
precondition(ReadingStore().favorites == original)
print("PASS: 8 complete poems, unique IDs, favorite toggle and persistence")
