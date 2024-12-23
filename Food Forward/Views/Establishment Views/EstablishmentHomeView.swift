import SwiftUI

struct EstablishmentHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var currentListings: [Listing] = []
    @State private var pickupListings: [Listing] = []
    @State private var isLoadingCurrent: Bool = false
    @State private var isLoadingPickups: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Display the establishment's name
                Text("Welcome, \(authViewModel.name)!")
                    .font(.title)
                    .fontWeight(.bold)
                
                NavigationLink(destination: CreateListingView(userID: authViewModel.getCurrentUserID() ?? "", claimedByUserId: "")) {
                    Text("Create a New Listing")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Divider()
                
                Text("Your Listings")
                    .font(.headline)
                    .padding(.top)
                
                if isLoadingCurrent {
                    ProgressView("Loading Listings...")
                        .padding()
                } else if currentListings.isEmpty {
                    Text("No listings available.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List(currentListings, id: \.id) { listing in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(listing.itemName)
                                .font(.headline)
                            Text("Quantity: \(listing.quantity)")
                                .font(.subheadline)
                            Text("Expires on: \(listing.expirationDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Text("Upcoming Pickups")
                    .font(.headline)
                    .padding(.top)
                if isLoadingPickups{
                    ProgressView("Loading Pickup Listings...")
                        .padding()
                }
                else if pickupListings.isEmpty {
                    Text("No Upcoming Pickups")
                        .foregroundColor(.secondary)
                        .padding()
                }
                else {
                    List(pickupListings, id: \.id) { listing in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(listing.itemName)
                                .font(.headline)
                            Text("Item Type: \(listing.itemType)")
                                .font(.subheadline)
                            Text("Qty: \(listing.quantity)")
                                .font(.subheadline)
                            Text("PickUp Time & Date")
                                .font(.subheadline)
                        }
                        .padding(.vertical,4)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Establishment Home")
        }
        .onAppear {
            fetchCurrentListings()
            fetchPickupsListings()
            authViewModel.fetchUserData()
        }
    }
    
    private func fetchCurrentListings() {
        isLoadingCurrent = true
        Food_Forward.fetchListings { fetchedListings in
            self.currentListings = fetchedListings.filter { $0.userId == authViewModel.getCurrentUserID() }
            self.isLoadingCurrent = false
        }
    }
    
    private func fetchPickupsListings() {
        isLoadingPickups = true
        Food_Forward.fetchListings { fetchedListings in
            self.pickupListings = fetchedListings.filter {
                $0.userId == authViewModel.getCurrentUserID() && $0.claimedByUserId?.isEmpty == false
            }
            self.isLoadingPickups = false
        }
    }
}
