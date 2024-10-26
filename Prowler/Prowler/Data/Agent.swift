import Foundation

struct Agent: Identifiable, Codable {
    var id: String { uuid } // Conformidad con Identifiable usando uuid
    let uuid: String
    let displayName: String
    let description: String?
    let displayIcon: String?
    let fullPortrait: String?
    let role: Role?
    let abilities: [Ability]
    let backgroundGradientColors: [String]?
    
    struct Role: Codable {
        let displayName: String
        let description: String?
        let displayIcon: String?
    }
    
    struct Ability: Codable, Identifiable {
        let id = UUID() // Genera un UUID para cumplir con Identifiable
        let slot: String
        let displayName: String
        let description: String?
        let displayIcon: String?
        enum CodingKeys: String, CodingKey {
                  case slot
                  case displayName
                  case description
                  case displayIcon
              }
    }
    
    static func example() -> Agent {
        return Agent(
            uuid: "5f8d3a7f-467b-97f3-062c-13acf203c006",
            displayName: "Jett",
            description: "Una duelista ágil con habilidades de movimiento rápido.",
            displayIcon: "https://media.valorant-api.com/agents/5f8d3a7f-467b-97f3-062c-13acf203c006/displayicon.png",
            fullPortrait: "https://media.valorant-api.com/agents/5f8d3a7f-467b-97f3-062c-13acf203c006/fullportrait.png",
            role: Role(
                displayName: "Duelista",
                description: "Ataca primero y abre espacio para su equipo.",
                displayIcon: "https://media.valorant-api.com/roles/5f8d3a7f-467b-97f3-062c-13acf203c006/displayicon.png"
            ),
            abilities: [
                Ability(
                    slot: "Ability1",
                    displayName: "Cloudburst",
                    description: "Lanza una nube que bloquea la visión.",
                    displayIcon: "https://media.valorant-api.com/agents/5f8d3a7f-467b-97f3-062c-13acf203c006/abilities/ability1/displayicon.png"
                ),
                // Agrega más habilidades según sea necesario
            ],
            backgroundGradientColors: ["#0F1923", "#FFFFFF"]
        )
    }
}
