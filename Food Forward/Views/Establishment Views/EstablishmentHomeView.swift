import SwiftUI

struct EstablishmentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var currentListings: [Listing] = []
    @State private var pickupListings: [Listing] = []
    @State private var isLoadingCurrent: Bool = false
    @State private var isLoadingPickups: Bool = false
    
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home
        case createListing
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case .home:
                    EstablishmentHomeView
                case .createListing:
                    CreateListingView(
                        userID: authViewModel.getCurrentUserID() ?? "",
                        claimedByUserId: ""
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Bottom Navigation Bar
            Divider()
            HStack {
                Spacer()
                Button(action: { selectedTab = .home }) {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                            .font(.caption)
                    }
                }
                .foregroundColor(selectedTab == .home ? .blue : .gray)
                Spacer()
                
                Button(action: { selectedTab = .createListing }) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create")
                            .font(.caption)
                    }
                }
                .foregroundColor(selectedTab == .createListing ? .blue : .gray)
                
                Spacer()
            }
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
        }
        .onAppear {
            fetchCurrentListings()
            fetchPickupsListings()
            authViewModel.fetchUserData()
        }
    }
    
    private var EstablishmentHomeView: some View {
        VStack(spacing: 16) {
            Text("Welcome, \(authViewModel.name)!")
                .font(.title)
                .fontWeight(.bold)
            
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(currentListings, id: \.id) { listing in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(listing.itemName)
                                    .font(.headline)
                                Text("Quantity: \(listing.quantity)")
                                    .font(.subheadline)
                                Text("Expires on: \(listing.expirationDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Text("Upcoming Pickups")
                .font(.headline)
                .padding(.top)
            
            if isLoadingPickups {
                ProgressView("Loading Pickup Listings...")
                    .padding()
            } else if pickupListings.isEmpty {
                Text("No Upcoming Pickups")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
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
                    .padding(.vertical, 4)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Establishment Home")
    }
    
    // Fetch Listings
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
