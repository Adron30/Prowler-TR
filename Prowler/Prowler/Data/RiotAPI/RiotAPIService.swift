import Foundation
class RiotAPIService {
    private var session = URLSession.shared
    private let region: ValorantRegion
    
    init(region: ValorantRegion) {
        self.region = region
    }
    
    func authenticate(username: String, password: String, completion: @escaping (Result<(String, String, String), Error>) -> Void) {
        let authURL = URL(string: "https://auth.riotgames.com/api/v1/authorization")!
        
        let initialData: [String: Any] = [
            "client_id": "play-valorant-web-prod",
            "nonce": "1",
            "redirect_uri": "https://playvalorant.com/opt_in",
            "response_type": "token id_token"
        ]
        
        var request = URLRequest(url: authURL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: initialData)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            print("Response String: \(responseString)")  // Aquí ves la respuesta completa

            do {
                guard let loginJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let response = loginJSON["response"] as? [String: Any],
                      let parameters = response["parameters"] as? [String: Any],
                      let uriString = parameters["uri"] as? String else {
                    print("Error parsing login response: \(responseString)")
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error parsing login response"])))
                    return
                }
                
                let pattern = "access_token=((?:[a-zA-Z]|\\d|\\.|-|_)*)"
                let regex = try? NSRegularExpression(pattern: pattern, options: [])
                if let match = regex?.firstMatch(in: uriString, options: [], range: NSRange(location: 0, length: uriString.utf16.count)),
                   let accessTokenRange = Range(match.range(at: 1), in: uriString) {
                    let accessToken = String(uriString[accessTokenRange])
                    
                    self.getEntitlementsToken(accessToken: accessToken) { result in
                        switch result {
                        case .success(let (entitlementsToken, userId)):
                            completion(.success((accessToken, entitlementsToken, userId)))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    print("Error: Failed to extract access token from URI.")
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to extract access token"])))
                }
            } catch {
                print("Error parsing login response: \(responseString)")
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error parsing login response: \(responseString)"])))
            }
        }.resume()
    }
    
    private func getEntitlementsToken(accessToken: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
        let entitlementsURL = URL(string: "https://entitlements.auth.riotgames.com/api/token/v1")!
        var request = URLRequest(url: entitlementsURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = Data()
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let entitlementsToken = json["entitlements_token"] as? String else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error parsing entitlements token"])))
                return
            }
            
            self.getUserID(accessToken: accessToken, entitlementsToken: entitlementsToken) { result in
                switch result {
                case .success(let userId):
                    completion(.success((entitlementsToken, userId)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    private func getUserID(accessToken: String, entitlementsToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        let userInfoURL = URL(string: "https://auth.riotgames.com/userinfo")!
        var request = URLRequest(url: userInfoURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue(entitlementsToken, forHTTPHeaderField: "X-Riot-Entitlements-JWT")
        request.httpBody = Data()
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let userId = json["sub"] as? String else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error parsing user ID"])))
                return
            }
            
            completion(.success(userId))
        }.resume()
    }
}
