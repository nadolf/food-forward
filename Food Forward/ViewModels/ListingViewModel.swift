import Firebase

func addListing(listing: Listing, complete: @escaping (Bool) -> Void) {
    let db = Firestore.firestore()
    let data: [String: Any] = [
        "userId": listing.userId,
        "claimedByUserId": listing.claimedByUserId ?? "",
        "imageURL": listing.imageURL ?? "",
        "itemName": listing.itemName,
        "itemDescription": listing.itemDescription,
        "itemType": listing.itemType,
        "quantity": listing.quantity,
        "expirationDate": listing.expirationDate,
        "status": listing.status,
        "timeCreated": listing.timeCreated
    ]
    db.collection("listings").addDocument(data: data) { error in
        if let error = error {
            print("Error saving listing: \(error.localizedDescription)")
            complete(false)
        } else {
            complete(true)
        }
    }
}


func fetchListings(completion: @escaping ([Listing]) -> Void) {
    let db = Firestore.firestore()
    db.collection("listings") // Corrected collection name to "listings"
        .order(by: "timeCreated", descending: true)
        .getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching listings: \(error.localizedDescription)")
                completion([])
            } else if let snapshot = snapshot {
                let listings = snapshot.documents.compactMap { document -> Listing? in
                    let data = document.data()
                    
                    // Parse data safely
                    guard let userId = data["userId"] as? String,
                          let claimedByUserId = data["claimedByUserId"] as? String,
                          let imageURL = data["imageURL"] as? String?,
                          let itemName = data["itemName"] as? String,
                          let itemDescription = data["itemDescription"] as? String,
                          let itemType = data["itemType"] as? String,
                          let quantity = data["quantity"] as? Int,
                          let expirationDate = (data["expirationDate"] as? Timestamp)?.dateValue(),
                          let status = data["status"] as? String,
                          let timeCreated = (data["timeCreated"] as? Timestamp)?.dateValue()
                    else {
                        return nil
                    }
                    
                    return Listing(
                        id: document.documentID,
                        userId: userId,
                        claimedByUserId: claimedByUserId,
                        imageURL: imageURL,
                        itemName: itemName,
                        itemDescription: itemDescription,
                        itemType: itemType,
                        quantity: quantity,
                        expirationDate: expirationDate,
                        status: status,
                        timeCreated: timeCreated
                    )
                }
                completion(listings)
            }
        }
}
