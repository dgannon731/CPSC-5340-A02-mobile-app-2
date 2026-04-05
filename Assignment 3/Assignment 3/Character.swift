
import Foundation

struct CharacterResponse: Decodable {
    let results: [Character]
}

struct Character: Identifiable, Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let origin: LocationReference
    let location: LocationReference
}

struct LocationReference: Decodable {
    let name: String
}
