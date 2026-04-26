import Foundation

struct ExerciseSet: Identifiable, Codable {
    var id: String
    var reps: Int?
    var weight: Double?
    var timeMinutes: Int?
    var distanceMiles: Double?

    init(
        id: String = UUID().uuidString,
        reps: Int? = nil,
        weight: Double? = nil,
        timeMinutes: Int? = nil,
        distanceMiles: Double? = nil
    ) {
        self.id = id
        self.reps = reps
        self.weight = weight
        self.timeMinutes = timeMinutes
        self.distanceMiles = distanceMiles
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String else {
            return nil
        }

        self.id = id
        self.reps = dictionary["reps"] as? Int
        self.weight = dictionary["weight"] as? Double
        self.timeMinutes = dictionary["timeMinutes"] as? Int
        self.distanceMiles = dictionary["distanceMiles"] as? Double
    }

    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "id": id
        ]

        if let reps = reps {
            dictionary["reps"] = reps
        }

        if let weight = weight {
            dictionary["weight"] = weight
        }

        if let timeMinutes = timeMinutes {
            dictionary["timeMinutes"] = timeMinutes
        }

        if let distanceMiles = distanceMiles {
            dictionary["distanceMiles"] = distanceMiles
        }

        return dictionary
    }
}
