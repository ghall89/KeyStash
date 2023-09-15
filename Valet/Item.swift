//
//  Item.swift
//  Valet
//
//  Created by Graham Hall on 9/15/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
