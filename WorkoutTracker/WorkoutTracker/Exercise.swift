import Foundation

struct Exercise: Identifiable, Codable {
    var id: String
    var name: String
    var muscleGroup: String
    var sets: [ExerciseSet]

    init(
        id: String = UUID().uuidString,
        name: String,
        muscleGroup: String,
        sets: [ExerciseSet]
    ) {
        self.id = id
        self.name = name
        self.muscleGroup = muscleGroup
        self.sets = sets
    }

    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let muscleGroup = dictionary["muscleGroup"] as? String,
            let setsArray = dictionary["sets"] as? [[String: Any]]
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.muscleGroup = muscleGroup
        self.sets = setsArray.compactMap { ExerciseSet(dictionary: $0) }
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "muscleGroup": muscleGroup,
            "sets": sets.map { $0.toDictionary() }
        ]
    }
}
