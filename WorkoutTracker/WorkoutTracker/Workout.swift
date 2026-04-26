import Foundation
import FirebaseFirestore

struct Workout: Identifiable, Codable {
    var id: String
    var name: String
    var date: Date
    var notes: String
    var isCompleted: Bool
    var exercises: [Exercise]

    init(
        id: String = UUID().uuidString,
        name: String,
        date: Date,
        notes: String,
        isCompleted: Bool,
        exercises: [Exercise]
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.notes = notes
        self.isCompleted = isCompleted
        self.exercises = exercises
    }

    init?(id: String, dictionary: [String: Any]) {
        guard
            let name = dictionary["name"] as? String,
            let timestamp = dictionary["date"] as? Timestamp,
            let notes = dictionary["notes"] as? String,
            let isCompleted = dictionary["isCompleted"] as? Bool,
            let exercisesArray = dictionary["exercises"] as? [[String: Any]]
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.date = timestamp.dateValue()
        self.notes = notes
        self.isCompleted = isCompleted
        self.exercises = exercisesArray.compactMap { Exercise(dictionary: $0) }
    }

    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "date": Timestamp(date: date),
            "notes": notes,
            "isCompleted": isCompleted,
            "exercises": exercises.map { $0.toDictionary() }
        ]
    }
}
