import Foundation

class RiotAPIService {
    private var session = URLSession.shared
    private let region: ValorantRegion
    
    init(region: ValorantRegion) {
        self.region = region
    }
    
    // Method to get Entitlements Token (already existing in your code)
    func getEntitlementsToken(accessToken: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
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
    
    // Method to get User ID (already existing in your code)
    func getUserID(accessToken: String, entitlementsToken: String, completion: @escaping (Result<String, Error>) -> Void) {
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
    
    // New method to fetch the Username using the User ID and Tokens
    func getUsername(accessToken: String, entitlementsToken: String, userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(region.baseURL)/name-service/v1/players")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue(entitlementsToken, forHTTPHeaderField: "X-Riot-Entitlements-JWT")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [userId])
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                  let user = json.first,
                  let gameName = user["GameName"] as? String,
                  let tagLine = user["TagLine"] as? String else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error parsing username"])))
                return
            }
            
            let username = "\(gameName)#\(tagLine)"
            completion(.success(username))
        }.resume()
    }
}
