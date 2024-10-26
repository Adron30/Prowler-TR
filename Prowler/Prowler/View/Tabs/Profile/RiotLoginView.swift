import SwiftUI

struct RiotLoginView: View {
    @State private var accessToken: AccessToken?
    @State private var authError: String?
    @State private var detectedRegion: ValorantRegion = .NA
    @State private var isShowingWebView = false
    
    var body: some View {
        VStack {
            if let token = accessToken {
                Text("Access Token: \(token.token)")
                    .padding()
                Text("ID Token: \(token.idToken)")
                    .padding()
                Text("Expiration: \(token.expiration)")
                    .padding()
                Text("Detected Region: \(detectedRegion.rawValue.uppercased())")
                    .padding()
            } else if let error = authError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button("Login with Riot") {
                isShowingWebView = true
            }
            .padding()
            .sheet(isPresented: $isShowingWebView) {
                WebViewContainer(url: RiotURL.rsoURL) { result, cookies in
                    isShowingWebView = false
                    switch result {
                    case .success(let token):
                        self.accessToken = token
                        fetchPlayerInfo(accessToken: token) { regionResult in
                            switch regionResult {
                            case .success(let region):
                                self.detectedRegion = region
                            case .failure(let error):
                                self.authError = error.localizedDescription
                            }
                        }
                    case .failure(let error):
                        self.authError = error.localizedDescription
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationTitle("Login to Valorant")
    }
    
    private func fetchPlayerInfo(accessToken: AccessToken, completion: @escaping (Result<ValorantRegion, Error>) -> Void) {
        guard let url = URL(string: "https://auth.riotgames.com/userinfo") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Player Info URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let region = json["region"] as? String {
                    completion(.success(ValorantRegion(rawValue: region.uppercased()) ?? .NA))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error parsing player info response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

#Preview {
    RiotLoginView()
}
