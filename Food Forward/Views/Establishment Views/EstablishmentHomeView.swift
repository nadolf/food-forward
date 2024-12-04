import SwiftUI

struct EstablishmentHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        Text("Hi, \(authViewModel.name)!")
        Text("Establishment View")
    }
}

//#Preview {
//    EstablishmentHomeView()
//}
