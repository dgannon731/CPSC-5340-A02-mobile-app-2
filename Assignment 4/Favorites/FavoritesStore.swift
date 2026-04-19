import Foundation
import FirebaseFirestore

final class FavoritesStore {
    private let db = Firestore.firestore()

    func loadFavorites(for uid: String, completion: @escaping (Result<UserFavorites, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data() else {
                completion(.success(UserFavorites()))
                return
            }

            let favorites = UserFavorites(
                favoriteCityIDs: data["favoriteCityIDs"] as? [Int] ?? [],
                favoriteHobbyIDs: data["favoriteHobbyIDs"] as? [Int] ?? [],
                favoriteBookIDs: data["favoriteBookIDs"] as? [Int] ?? []
            )

            completion(.success(favorites))
        }
    }

    func saveFavorites(_ favorites: UserFavorites, for uid: String, completion: ((Error?) -> Void)? = nil) {
        let data: [String: Any] = [
            "favoriteCityIDs": favorites.favoriteCityIDs,
            "favoriteHobbyIDs": favorites.favoriteHobbyIDs,
            "favoriteBookIDs": favorites.favoriteBookIDs
        ]

        db.collection("users").document(uid).setData(data) { error in
            completion?(error)
        }
    }
}
