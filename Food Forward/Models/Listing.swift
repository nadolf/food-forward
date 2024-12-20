import Foundation

struct Listing {
    var id: String
    var userId: String
    var claimedByUserId: String?
    var imageURL: String?
    var itemName: String
    var itemDescription: String
    var itemType: String
    var quantity: Int
    var expirationDate: Date
    var status: String
    var timeCreated: Date
}
