//
//  ArrayExtensions.swift
//  ClaraClaraGames
//
//  Created by James Philhower on 6/27/23.
//

import SwiftUI

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
