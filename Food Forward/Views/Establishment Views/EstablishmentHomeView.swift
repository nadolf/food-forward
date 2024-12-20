import SwiftUI

struct EstablishmentHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Display the establishment's name
                Text("Welcome, \(authViewModel.name)!")
                    .font(.title)
                    .fontWeight(.bold)

                if !authViewModel.bio.isEmpty {
                    Text(authViewModel.bio)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                NavigationLink(destination: CreateListingView(userID: authViewModel.getCurrentUserID() ?? "", claimedByUserId: "")) {
                    Text("Create a New Listing")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Establishment Home")
        }
        .onAppear {
            authViewModel.fetchUserData()
        }
    }
}
