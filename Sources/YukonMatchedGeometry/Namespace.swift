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
        var insertionFrames = [AnyHashable: [Bool: CGRect]]()
        var insertionAnchors = [AnyHashable: [Bool: UnitPoint]]()
    }

    public let wrappedValue = ID()

    public init() {}
}

extension Namespace.ID {
    func update(id: AnyHashable, key: Bool, frame: CGRect) {
        var dict = insertionFrames[id] ?? [:]
        if dict[key] != frame {
            dict[key] = frame
            insertionFrames[id] = dict
        }
    }
    func update(id: AnyHashable, key: Bool, anchor: UnitPoint) {
        var dict = insertionAnchors[id] ?? [:]
        if dict[key] != anchor {
            dict[key] = anchor
            insertionAnchors[id] = dict
        }
    }
}
