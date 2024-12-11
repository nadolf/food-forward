import SwiftUI

struct SignUpSelectionView: View {
    var body: some View {
        NavigationStack{
            // Logo Icon
            VStack{
                Text("Create your account").bold()
                HStack{
                    Text("Already have an account?")
                    Button("Sign In") {
                        //
                    }
                }
                NavigationLink(destination: IndividualSignUpView()){
                    Text("Individual or Organization")
                }
                NavigationLink(destination: EstablishmentSignUpView()){
                    Text("Resturants or Grocery Stores")
                }
            }
        }
    }
}

#Preview {
    SignUpSelectionView()
}
