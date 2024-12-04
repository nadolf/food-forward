import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Food_ForwardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                HomeView().environmentObject(authViewModel)
            } else {
                NavigationView {
                    VStack {
                        NavigationLink("Sign Up as Individual", destination: IndividualSignUpView())
                        NavigationLink("Sign Up as Establishment", destination: EstablishmentSignUpView())
                        NavigationLink("Already have an account? Sign In", destination: SignInView())
                    }
                }
                .environmentObject(authViewModel)
            }
        }
    }
}
