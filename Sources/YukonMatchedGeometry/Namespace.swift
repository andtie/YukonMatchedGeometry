//
//  Namespace.swift
// 
//
//  Created by Tielmann, Andreas on 07.07.2020.
//

import SwiftUI

@propertyWrapper public struct Namespace: DynamicProperty {

    // swiftlint:disable:next type_name
    public class ID {
        var sourceFrames = [AnyHashable: CGRect]()
        var sourceAnchors = [AnyHashable: UnitPoint]()
    }

    public let wrappedValue = ID()

    public init() {}
}
