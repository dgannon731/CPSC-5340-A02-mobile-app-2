import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        listenForAuthChanges()
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func listenForAuthChanges() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }

    func signUp(email: String, password: String) {
        errorMessage = ""

        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required."
            return
        }

        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error as NSError? {
                    print("Firebase signUp error: \(error)")
                    print("Firebase signUp code: \(error.code)")
                    print("Firebase signUp userInfo: \(error.userInfo)")
                    self?.errorMessage = self?.friendlyErrorMessage(for: error) ?? error.localizedDescription
                    return
                }

                self?.errorMessage = ""
            }
        }
    }

    func signIn(email: String, password: String) {
        errorMessage = ""

        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required."
            return
        }

        isLoading = true

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error as NSError? {
                    print("Firebase signIn error: \(error)")
                    print("Firebase signIn code: \(error.code)")
                    print("Firebase signIn userInfo: \(error.userInfo)")
                    self?.errorMessage = self?.friendlyErrorMessage(for: error) ?? error.localizedDescription
                    return
                }

                self?.errorMessage = ""
            }
        }
    }

    func signOut() {
        errorMessage = ""

        do {
            try Auth.auth().signOut()
        } catch {
            print("Firebase signOut error: \(error)")
            errorMessage = "Could not sign out."
        }
    }

    private func friendlyErrorMessage(for error: NSError) -> String? {
        guard let code = AuthErrorCode(rawValue: error.code) else {
            return error.localizedDescription
        }

        switch code {
        case .wrongPassword, .invalidCredential:
            return "Incorrect email or password."
        case .invalidEmail:
            return "Invalid email address."
        case .emailAlreadyInUse:
            return "That email is already in use."
        case .weakPassword:
            return "Password must be at least 6 characters."
        case .userNotFound:
            return "No account found for that email."
        case .operationNotAllowed:
            return "Email/password sign-in is not enabled in Firebase Console."
        default:
            return error.localizedDescription
        }
    }
}
