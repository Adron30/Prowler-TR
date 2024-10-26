import Foundation

class ValorantAPIService {
    func fetchData<T: Codable>(from endpoint: ValorantEndpoint, completion: @escaping (Result<[T], Error>) -> Void) {
        guard let url = URL(string: endpoint.url) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Datos inválidos"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ValorantResponse<T>.self, from: data)
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum ValorantEndpoint {
    case agents
    case weapons

    var url: String {
        let baseURL = "https://valorant-api.com/v1"
        let languageCode: String

        switch Locale.current.language.languageCode?.identifier {
        case "es":
            languageCode = "es-ES"
        case "en":
            languageCode = "en-US"
        default:
            languageCode = "en-US" // Valor predeterminado
        }

        switch self {
        case .agents:
            return "\(baseURL)/agents?isPlayableCharacter=true&language=\(languageCode)"
        case .weapons:
            return "\(baseURL)/weapons?language=\(languageCode)"
        }
    }
}

struct ValorantResponse<T: Codable>: Codable {
    let status: Int
    let data: [T]
}
