import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome, \(authViewModel.firstName.isEmpty ? "Guest" : authViewModel.firstName)!")
                    .font(.largeTitle)
                    .padding()
                
                Button("Sign Out") {
                    authViewModel.signOut()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            }.navigationBarBackButtonHidden(true)
        }
    }


#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
