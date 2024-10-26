import Foundation

func authenticateAndGetTokens(username: String, password: String, completion: @escaping (String?, Error?) -> Void) {
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

        // Aquí parseamos la respuesta para obtener los tokens
        // NOTA: Sigue el repositorio y la documentación específica para saber cómo manejar esto
        let responseString = String(data: data, encoding: .utf8)
        print("Response: \(responseString ?? "")")

        // Simulación: devolver un token
        completion("fake_token_for_demo_purposes", nil)
    }
    task.resume()
}
