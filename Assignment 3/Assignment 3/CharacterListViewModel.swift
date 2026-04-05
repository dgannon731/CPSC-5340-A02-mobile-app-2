import Foundation
import Combine

@MainActor
final class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = CharacterService()

    func loadCharacters() async {
        isLoading = true
        errorMessage = nil

        do {
            characters = try await service.fetchCharacters()
        } catch {
            errorMessage = "Failed to load characters."
            print("Error loading characters: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
