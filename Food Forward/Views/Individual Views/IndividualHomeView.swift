import SwiftUI

struct IndividualHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var listings: [Listing] = [] // State to hold fetched listings
    @State private var isLoading: Bool = false // Loading indicator
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Welcome Text
                Text("Hi, \(authViewModel.firstName)!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Available Listings")
                    .font(.headline)
                    .padding(.top)
                
                // Loading Indicator
                if isLoading {
                    ProgressView("Loading Listings...")
                        .padding()
                }
                // No Listings State
                else if listings.isEmpty {
                    Text("No listings available at the moment.")
                        .foregroundColor(.secondary)
                        .padding()
                }
                // Display Listings
                else {
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
            .navigationTitle("Individual Home")
        }
        .onAppear {
            fetchAllListings()
            authViewModel.fetchUserData()
        }
    }
    
    private func fetchAllListings() {
        isLoading = true
        fetchListings { fetchedListings in
            self.listings = fetchedListings
            self.isLoading = false
        }
    }
}
