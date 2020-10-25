import Entities

extension Item {
    var formattedWeight: String {
        return weight.formattedWeight(authorUnit)
    }
}
