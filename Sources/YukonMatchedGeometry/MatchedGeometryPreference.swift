//
//  MatchedGeometryPreference.swift
//  MatchedGeometry
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 07.07.2020.
//  Copyright © 2020 Tielmann. All rights reserved.
//

import SwiftUI

struct MatchedGeometryPreference: PreferenceKey {

    typealias Value = [AnyHashable: CGRect]

    static var defaultValue: Value { [:] }

    static func reduce(value: inout Value, nextValue: () -> Value) {
        for (id, frame) in nextValue() {
            value[id] = frame
        }
    }
}
