//
//  creditsView.swift
//  Prowler
//
//  Created by Marc Moreno on 23/7/24.
//

import SwiftUI

struct aboutDevView: View {
    var body: some View {
        Image(.iconMarc)
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/
            )
            .padding()
        Text("key_developer_text")
            .multilineTextAlignment(.center)
            .padding()
    }
}

#Preview {
    aboutDevView()
}
