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
        var sources = [AnyHashable: ViewInfo]()
        var transitions = [AnyHashable: [UUID: ViewInfo]]()
    }

    public let wrappedValue = ID()

    public init() {}

    struct ViewInfo: Equatable {
        let frame: CGRect
        let anchor: UnitPoint
    }
}
