import SwiftUI
import PhotosUI

struct IndividualSignUpView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State var selectedPhoto: [PhotosPickerItem] = []

    var body: some View {
        NavigationStack {
            VStack {
                Text("Create Account")
                    .font(.title)
                    .padding(.top, 20)
                
                // Profile Photo Icon
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
                
                // Text Fields Sections
                TextField("First Name", text: $authViewModel.firstName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                TextField("Last Name", text: $authViewModel.lastName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                TextField("Email Address", text: $authViewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                SecureField("Password", text: $authViewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                SecureField("Confirm Password", text: $authViewModel.confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                TextField("Address", text: $authViewModel.address)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                TextField("Phone Number", text: $authViewModel.phoneNumber)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Button("Create Account") {
                    authViewModel.accountType = "individual"
                    authViewModel.signUp()
                }
                .buttonStyle(.borderedProminent)
                .alert(authViewModel.alertMessage, isPresented: $authViewModel.showAlert) {}
                
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true) // Hide the back button here
        }
    }
}

#Preview {
    IndividualSignUpView()
}
