import SwiftUI

struct EstablishmentHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var listings: [Listing] = []
    @State private var isLoading: Bool = false
    
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
                
                if isLoading {
                    ProgressView("Loading Listings...")
                        .padding()
                } else if listings.isEmpty {
                    Text("No listings available.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List(listings, id: \.id) { listing in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(listing.itemName)
                                .font(.headline)
                            Text("Description: \(listing.itemDescription)")
                                .font(.subheadline)
                            Text("Quantity: \(listing.quantity)")
                                .font(.subheadline)
                            Text("Expires on: \(listing.expirationDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Establishment Home")
        }
        .onAppear {
            fetchListings()
            authViewModel.fetchUserData()
        }
    }
    
    private func fetchListings() {
        isLoading = true
        Food_Forward.fetchListings { fetchedListings in
            self.listings = fetchedListings.filter { $0.userId == authViewModel.getCurrentUserID() }
            self.isLoading = false
        }
    }
}
