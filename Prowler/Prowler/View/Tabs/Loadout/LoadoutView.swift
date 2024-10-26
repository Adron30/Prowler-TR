//


import SwiftUI

struct LoadoutView: View {
    let agents: [Agent]
    var body: some View {
            ListAgentsWeaponsView(agents: agents)
    }
}
#Preview{
    LoadoutView(agents: [])
}
