import SwiftUI

struct RiotLoginView: View {
    @State private var username: String = ""
       @State private var password: String = ""
       @State private var selectedRegion: ValorantRegion = .NA
       @State private var isAuthenticating: Bool = false
       @State private var authenticationError: String?

       var body: some View {
           NavigationStack {
               VStack(spacing: 20) {
                   TextField("Username", text: $username)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .autocapitalization(.none)
                       .padding(.horizontal)
                   
                   SecureField("Password", text: $password)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .padding(.horizontal)
                   
                   Picker("Select Region", selection: $selectedRegion) {
                       Text("North America").tag(ValorantRegion.NA)
                       Text("Europe").tag(ValorantRegion.EU)
                       Text("Asia Pacific").tag(ValorantRegion.AP)
                       Text("Korea").tag(ValorantRegion.KO)
                   }
                   .pickerStyle(SegmentedPickerStyle())
                   .padding(.horizontal)
                   
                   if isAuthenticating {
                       ProgressView("Authenticating...")
                   } else {
                       Button("Login") {
                           authenticateUser()
                       }
                       .buttonStyle(.borderedProminent)
                   }
                   
                   if let error = authenticationError {
                       Text(error)
                           .foregroundColor(.red)
                           .multilineTextAlignment(.center)
                           .padding(.horizontal)
                   }
                   
                   Spacer()
               }
               .navigationTitle("Login to Valorant")
               .padding(.top, 50)
           }
       }
       
       private func authenticateUser() {
           isAuthenticating = true
           authenticationError = nil
           
           let riotService = RiotAPIService(region: selectedRegion)
           riotService.authenticate(username: username, password: password) { result in
               DispatchQueue.main.async {
                   isAuthenticating = false
                   
                   switch result {
                   case .success(let (accessToken, entitlementsToken, userId)):
                       print("Access Token: \(accessToken)")
                       print("Entitlements Token: \(entitlementsToken)")
                       print("User ID: \(userId)")
                       // Aquí puedes almacenar los tokens o proceder con otras solicitudes
                   case .failure(let error):
                       authenticationError = "Authentication failed: \(error.localizedDescription)"
                   }
               }
           }
       }
   }

#Preview {
    RiotLoginView()
}
