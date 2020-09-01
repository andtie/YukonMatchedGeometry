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
        if namespace.sourceFrames[id] != frame {
            namespace.sourceFrames[id] = frame
            namespace.sourceAnchors[id] = anchor
        }
    }

    func save(insertionFrame frame: CGRect?, uuid: UUID) {
        guard isSource, let frame = frame else { return }
        let values = Array((namespace.insertionFrames[id] ?? [:]).values)
        guard values.first == values.last else { return }

        var framesDict = namespace.insertionFrames[id] ?? [:]
        framesDict[uuid] = frame
        namespace.insertionFrames[id] = framesDict

        var anchorsDict = namespace.insertionAnchors[id] ?? [:]
        anchorsDict[uuid] = anchor
        namespace.insertionAnchors[id] = anchorsDict
    }

    func parameters(for frame: CGRect?) -> MatchedGeometryParameters? {
        guard
            !isSource,
            let frame = frame,
            let sourceFrame = namespace.sourceFrames[id],
            let sourceAnchor = namespace.sourceAnchors[id] else {
                return nil
        }
        return MatchedGeometryParameters(
            frame: frame,
            sourceFrame: sourceFrame,
            properties: properties,
            anchor: anchor,
            sourceAnchor: sourceAnchor
        )
    }

    func transitionParameters(for frame: CGRect?, uuid: UUID) -> MatchedGeometryParameters? {
        guard
            let frame = namespace.insertionFrames[id]?[uuid],
            let sourceFrame = namespace.insertionFrames[id]?.first(where: { $0.key != uuid })?.value,
            let sourceAnchor = namespace.insertionAnchors[id]?.first(where: { $0.key != uuid })?.value else {
                return nil
        }
        let params = MatchedGeometryParameters(
            frame: frame,
            sourceFrame: sourceFrame,
            properties: properties,
            anchor: anchor,
            sourceAnchor: sourceAnchor
        )
        return params
    }
}
