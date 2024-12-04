import SwiftUI

struct IndividualHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        Text("Hi, \(authViewModel.firstName)!")
        Text("Individual View")
    }
}

//#Preview {
//    IndividualHomeView()
//}
