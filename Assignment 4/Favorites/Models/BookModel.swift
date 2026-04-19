

import Foundation

struct BookModel: Identifiable {
    let id: Int
    let bookTitle: String
    let bookAuthor: String
    var isFavorite: Bool
}
