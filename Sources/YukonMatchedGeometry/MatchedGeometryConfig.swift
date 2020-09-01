//
//  MatchedGeometryConfig.swift
//  
//
//  Created by Tielmann, Andreas on 07.07.2020.
//

import SwiftUI

struct MatchedGeometryConfig<ID: Hashable>: Equatable {

    static func == (lhs: MatchedGeometryConfig<ID>, rhs: MatchedGeometryConfig<ID>) -> Bool {
        lhs.id == rhs.id
            && lhs.namespace === rhs.namespace
            && lhs.properties == rhs.properties
            && lhs.anchor == rhs.anchor
            && lhs.isSource == rhs.isSource
    }

    let id: ID //swiftlint:disable:this identifier_name
    let namespace: Namespace.ID
    let properties: MatchedGeometryProperties
    let anchor: UnitPoint
    let isSource: Bool

    func save(frame: CGRect?) {
        guard isSource, let frame = frame else { return }
        namespace.sources[id] = Namespace.ViewInfo(frame: frame, anchor: anchor)
    }

    func save(transitionFrame frame: CGRect?, uuid: UUID) {
        guard isSource,
              let frame = frame,
              let keyCount = namespace.transitions[id]?.keys.count,
              keyCount < 2 else {
            return
        }
        var infoDict = namespace.transitions[id] ?? [:]
        infoDict[uuid] = .init(frame: frame, anchor: anchor)
        namespace.transitions[id] = infoDict
    }

    func parameters(for frame: CGRect?) -> MatchedGeometryParameters {
        guard !isSource,
              let frame = frame,
              let source = namespace.sources[id] else {
            return .zero
        }
        return MatchedGeometryParameters(
            frame: frame,
            sourceFrame: source.frame,
            properties: properties,
            anchor: anchor,
            sourceAnchor: source.anchor
        )
    }

    func transitionParameters(for frame: CGRect?, uuid: UUID) -> MatchedGeometryParameters {
        guard let dict = namespace.transitions[id],
              let info = dict[uuid],
              let sourceInfo = dict.first(where: { $0.key != uuid })?.value else {
            return .zero
        }
        return MatchedGeometryParameters(
            frame: info.frame,
            sourceFrame: sourceInfo.frame,
            properties: [properties],
            anchor: info.anchor,
            sourceAnchor: sourceInfo.anchor
        )
    }
}
