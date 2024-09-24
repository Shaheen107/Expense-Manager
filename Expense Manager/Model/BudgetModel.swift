import Foundation

struct Budget: Codable {
    var name: String
    var amount: Double
    var date: Date
    var savedAmount: Double = 0.0 // Default saved amount is 0
    var category: String? // Optional category to link it with expenses
}
