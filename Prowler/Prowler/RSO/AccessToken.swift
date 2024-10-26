//
//  AccessToken.swift
//  Prowler
//
//  Created by Marc Moreno on 27/7/24.
//

import SwiftUI

struct AccessToken: Codable, Hashable {
    var type: String
    var token: String
    var idToken: String
    var expiration: Date
    
    var encoded: String {
        "\(type) \(token)"
    }
    
    var hasExpired: Bool {
        expiration < .now
    }
}
