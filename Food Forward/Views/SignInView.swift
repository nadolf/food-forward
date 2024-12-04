import SwiftUI

struct SignInView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var rememberMeCheckbox = false

    var body: some View {
        NavigationStack {
            VStack {
                // Logo or Title
                Text("Welcome to Food Forward")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)

                // Email and Password Input Fields
                TextField("Email", text: $authViewModel.email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.bottom, 20)

                SecureField("Password", text: $authViewModel.password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom, 40)

                // Remember Me and Forgot Password Section
                HStack {
                    Toggle(isOn: $rememberMeCheckbox) {
                        Text("Remember Me")
                    }

                    Spacer()

                    Button("Forget Password?") {
                        // Navigate to Reset Password Page
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 20)

                // Sign In Button
                Button("Sign In") {
                    authViewModel.signIn()
                }
                .buttonStyle(.borderedProminent)
                .alert(authViewModel.alertMessage, isPresented: $authViewModel.showAlert) {
                    Button("OK", role: .cancel) {}
                }

                // Navigation Link for Sign-Up
                NavigationLink("Don't have an account? Sign Up", destination: IndividualSignUpView())
                    .padding(.top)
            }
            .padding()

            // Navigation to HomeView when authenticated
            .navigationDestination(isPresented: $authViewModel.isAuthenticated) {
                if authViewModel.accountType == "individual" {
                    IndividualHomeView().environmentObject(authViewModel)
                } else if authViewModel.accountType == "establishment" {
                    EstablishmentHomeView().environmentObject(authViewModel)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignInView()
}
