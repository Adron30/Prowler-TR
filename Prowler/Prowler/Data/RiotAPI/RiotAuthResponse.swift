import Foundation

struct RiotAuthResponse: Codable {
    let type: String
    let error: String?
    let country: String?
    let response: RiotAuthSuccessResponse?
}

struct RiotAuthSuccessResponse: Codable {
    let mode: String
    let parameters: RiotAuthParameters?
}

struct RiotAuthParameters: Codable {
    let uri: String?
}

func authenticateWithRiot(username: String, password: String, completion: @escaping (String?, Error?) -> Void) {
    // Step 1: Iniciar la sesión y obtener cookies
    let url = URL(string: "https://auth.riotgames.com/api/v1/authorization")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = [
        "client_id": "play-valorant-web-prod",
        "nonce": "1",
        "redirect_uri": "https://playvalorant.com/opt_in",
        "response_type": "token id_token",
        "scope": "account openid"
    ]

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    } catch {
        completion(nil, error)
        return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(nil, error)
            return
        }

        guard let data = data else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
            return
        }

        do {
            // Decodificar la respuesta de Riot
            let authResponse = try JSONDecoder().decode(RiotAuthResponse.self, from: data)

            if let authError = authResponse.error {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Auth error: \(authError)"]))
                return
            }

            guard let uri = authResponse.response?.parameters?.uri else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No redirect URI received"]))
                return
            }

            // Extraer el token de la URI de redirección
            if let accessToken = extractToken(from: uri, tokenName: "access_token") {
                completion(accessToken, nil)
            } else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No access token found"]))
            }

        } catch {
            completion(nil, error)
        }
    }
    task.resume()
}

func extractToken(from uri: String, tokenName: String) -> String? {
    guard let urlComponents = URLComponents(string: uri) else {
        return nil
    }
    return urlComponents.queryItems?.first(where: { $0.name == tokenName })?.value
}
