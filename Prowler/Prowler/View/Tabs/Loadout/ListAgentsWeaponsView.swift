import SwiftUI

struct ListAgentsWeaponsView: View {
    let agents: [Agent] // Lista de agentes proporcionada como parámetro.
    @StateObject private var weaponsViewModel = WeaponsViewModel()
    
    @State private var selectedAgent: Agent? = nil // Estado para el agente seleccionado.
    @State private var selectedWeapon: Weapon? = nil // Estado para el arma seleccionada.
    
    var body: some View {
        NavigationSplitView {
            List {
                Section(header: Text("key_agents").font(.headline)) {
                    ForEach(agents, id: \.uuid) { agent in
                        NavigationLink(destination: AgentDetailListView(agent: agent)) {
                            HStack {
                                if let url = URL(string: agent.displayIcon ?? "") {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                Text(agent.displayName)
                                    .font(.headline)
                            }
                        }
                    }
                }
                
                Section(header: Text("key_weapons").font(.headline)) {
                    ForEach(weaponsViewModel.weapons, id: \.uuid) { weapon in
                        HStack {
                            Text(weapon.displayName)
                                .font(.headline)
                            // Evita que las armas se vean (es que se ven muy mal)
                            // if let url = URL(string: weapon.displayIcon ?? "") {
                            //     AsyncImage(url: url) { image in
                            //         image.resizable()
                            //     } placeholder: {
                            //         ProgressView()
                            //     }
                            //     .scaledToFit()
                            //     .frame(width: 50)
                            //     .border(Color.black)
                            // }
                        }
                    }
                }
            }
            .navigationTitle("key_loadout")
            .onAppear {
                weaponsViewModel.loadWeapons()
            }
        } detail: {
            if let agent = selectedAgent {
                AgentDetailView(agent: agent) // Detalle del agente seleccionado.
            } else if let weapon = selectedWeapon {
                WeaponDetailView(weapon: weapon) // Detalle del arma seleccionada.
            } 
        }
    }
}

// Vistas de Detalle (Ejemplos Simples)
struct AgentDetailView: View {
    let agent: Agent
    
    var body: some View {
        VStack {
            Text(agent.displayName)
                .font(.largeTitle)
            if let url = URL(string: agent.displayIcon ?? "") {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .padding()
    }
}

struct WeaponDetailView: View {
    let weapon: Weapon
    
    var body: some View {
        VStack {
            Text(weapon.displayName)
                .font(.largeTitle)
            if let url = URL(string: weapon.displayIcon ?? "") {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ListAgentsWeaponsView(agents: [])
}
