import Foundation

class AgentsViewModel: ObservableObject {
    @Published var agents: [Agent] = []
    private var service = ValorantAPIService()

    func loadAgents() {
        service.fetchData(from: .agents) { (result: Result<[Agent], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let agents):
                    self.agents = agents
                case .failure(let error):
                    print("Error al obtener agentes: \(error)")
                }
            }
        }
    }
}
