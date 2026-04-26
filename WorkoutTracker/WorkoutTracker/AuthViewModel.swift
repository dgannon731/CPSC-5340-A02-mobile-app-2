import Foundation
import Combine
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var errorMessage: String = ""

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        self.user = Auth.auth().currentUser

        authStateListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            Task { @MainActor in
                self.user = user
            }
        }
    }

    func signUp(email: String, password: String) {
        errorMessage = ""

        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            Task { @MainActor in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func signIn(email: String, password: String) {
        errorMessage = ""

        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            Task { @MainActor in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
