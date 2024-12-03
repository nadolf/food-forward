import SwiftUI
import PhotosUI

struct IndividualSignUpView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State var selectedPhoto: [PhotosPickerItem] = []

    var body: some View{
        VStack{
            Text("Create Account")
            
            //Profile Photo Icon
            ZStack {
                // Circle background
                Circle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 100)

                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 4)
            )
            
            PhotosPicker(selection: $selectedPhoto,
                         matching: .any(of: [.images, .not(.screenshots)])) {
                Text("Change Profile Picture")
            }
            
            //Text Fields Sections
            TextField("First Name", text: $authViewModel.firstName)
            TextField("Last Name", text: $authViewModel.lastName)
            TextField("Email Address", text: $authViewModel.email)
            SecureField("Password", text: $authViewModel.password)
            SecureField("Confirm Password", text: $authViewModel.confirmPassword)
            TextField("Address", text: $authViewModel.address)
            TextField("Phone Number", text: $authViewModel.phoneNumber)
            
            Button("Create Account"){}.buttonStyle(.borderedProminent)
        }
    }
    
}

#Preview {
    IndividualSignUpView()
}
