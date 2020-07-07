//
//  Namespace.swift
//  MatchedGeometry
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 07.07.2020.
//  Copyright © 2020 Tielmann. All rights reserved.
//

import SwiftUI

@propertyWrapper public struct Namespace: DynamicProperty {

    public class ID {
        var value = MatchedGeometryPreference.defaultValue
    }

    public let wrappedValue = ID()

    public init() {}
}
