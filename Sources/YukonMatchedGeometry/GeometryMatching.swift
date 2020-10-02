//
// GeometryMatching.swift
//
// Created by Andreas in 2020
//

import SwiftUI

public class GeometryMatching: Equatable {
    lazy var sources = [AnyHashable: Geometry]()
    lazy var transitions = [AnyHashable: [UUID: Geometry]]()

    fileprivate func isEqual(to matching: GeometryMatching) -> Bool {
        sources == matching.sources && transitions == matching.transitions
    }

    public static func == (lhs: GeometryMatching, rhs: GeometryMatching) -> Bool {
        lhs.isEqual(to: rhs)
    }
}

struct Geometry: Equatable {
    let frame: CGRect
    let anchor: UnitPoint
}

public class GeometryMatchingWithFallback: GeometryMatching {
    private var _id: Any?

    override func isEqual(to matching: GeometryMatching) -> Bool {
        guard super.isEqual(to: matching),
              let matching = matching as? GeometryMatchingWithFallback,
              #available(iOS 14.0, *)
        else {
            return false
        }
        return _id as? SwiftUI.Namespace.ID == matching._id as? SwiftUI.Namespace.ID
    }

    @available(iOS 14.0, *)
    private static var usedIds = Set<SwiftUI.Namespace.ID>()

    @available(iOS 14.0, *)
    func id(default id: @autoclosure () -> SwiftUI.Namespace.ID) -> SwiftUI.Namespace.ID? {
        if let _id = _id as? SwiftUI.Namespace.ID { return _id }
        let id = id()
        if Self.usedIds.contains(id) { return nil }
        Self.usedIds.insert(id)
        _id = id
        return id
    }
}
