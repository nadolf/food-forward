import SwiftUI

struct CreateListingView: View {
    @State private var itemName = ""
    @State private var itemType = ""
    @State private var itemDescription = ""
    @State private var quantity = ""
    @State private var expirationDate = Date()
    @Environment(\.dismiss) var dismiss

    var userID: String
    var claimedByUserId: String

    var body: some View {
        Form {
            Section(header: Text("Item Details")) {
                TextField("Item Name", text: $itemName)
                TextField("Item Type", text: $itemType)
                TextField("Item Description", text: $itemDescription)
                
                TextField("Quantity", text: $quantity)
                    .keyboardType(.numberPad)
                
                DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
            }
            
            Section {
                Button(action: saveListing) {
                    Text("Save")
                }
            }
        }
        .navigationTitle("Create Listing")
    }

    // Save listing action
    private func saveListing() {
        guard let quantityValue = Int(quantity), !itemName.isEmpty, !itemType.isEmpty, !itemDescription.isEmpty else {
            print("All fields must be filled and quantity must be a number.")
            return
        }
        
        let newListing = Listing(
            id: UUID().uuidString,
            userId: userID,
            claimedByUserId: nil,
            imageURL: nil,
            itemName: itemName,
            itemDescription: itemDescription,
            itemType: itemType,
            quantity: quantityValue, // Int value converted earlier
            expirationDate: expirationDate,
            status: "Available",
            timeCreated: Date()
        )

        
        addListing(listing: newListing) { success in
            if success {
                dismiss()
            } else {
                print("Failed to save listing.")
            }
        }
    }
}


