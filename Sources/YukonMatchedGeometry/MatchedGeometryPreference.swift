//
//  MatchedGeometryPreference.swift
// 
//
//  Created by Tielmann, Andreas on 07.07.2020.
//

import SwiftUI

struct MatchedGeometryPreference: PreferenceKey {

    typealias Value = CGRect?

    static var defaultValue: Value = nil

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
