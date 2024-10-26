import Foundation

class WeaponsViewModel: ObservableObject {
    @Published var weapons: [Weapon] = []
    private var service = ValorantAPIService()

    func loadWeapons() {
        service.fetchData(from: .weapons) { (result: Result<[Weapon], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let weapons):
                    self.weapons = weapons
                case .failure(let error):
                    print("Error al obtener armas: \(error)")
                }
            }
        }
    }
}
