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

    let id: ID
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

    func save(transitionFrame frame: CGRect?, key: Bool) {
        guard isSource, let frame = frame else { return }
        let dict = namespace.insertionFrames[id]
        if dict?[key] != nil && dict?[key] != dict?[!key] { return }
        namespace.update(id: id, key: key, frame: frame)
        namespace.update(id: id, key: key, anchor: anchor)
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

    func transitionParameters(for frame: CGRect?, key: Bool) -> MatchedGeometryParameters? {
        guard
            let frame = namespace.insertionFrames[id]?[key],
            let sourceFrame = namespace.insertionFrames[id]?[!key],
            let sourceAnchor = namespace.insertionAnchors[id]?[!key] else {
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
