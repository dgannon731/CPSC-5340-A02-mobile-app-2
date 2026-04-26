import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

@MainActor
class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var errorMessage: String = ""

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func fetchWorkouts() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No user is currently signed in."
            return
        }

        listener?.remove()

        listener = db.collection("users")
            .document(userId)
            .collection("workouts")
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                Task { @MainActor in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        self.workouts = []
                        return
                    }

                    self.workouts = documents.compactMap { document in
                        Workout(id: document.documentID, dictionary: document.data())
                    }
                }
            }
    }

    func addWorkout(_ workout: Workout) {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No user is currently signed in."
            return
        }

        db.collection("users")
            .document(userId)
            .collection("workouts")
            .document(workout.id)
            .setData(workout.toDictionary()) { error in
                Task { @MainActor in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
    }

    func deleteWorkout(_ workout: Workout) {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No user is currently signed in."
            return
        }

        db.collection("users")
            .document(userId)
            .collection("workouts")
            .document(workout.id)
            .delete { error in
                Task { @MainActor in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
    }

    func toggleCompleted(_ workout: Workout) {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No user is currently signed in."
            return
        }

        db.collection("users")
            .document(userId)
            .collection("workouts")
            .document(workout.id)
            .updateData([
                "isCompleted": !workout.isCompleted
            ]) { error in
                Task { @MainActor in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
    }
}
