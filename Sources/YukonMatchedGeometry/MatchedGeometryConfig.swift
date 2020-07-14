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

    var sourceFrame: CGRect? {
        namespace.sourceFrames[id]
    }

    var sourceAnchor: UnitPoint {
        namespace.sourceAnchors[id] ?? .center
    }

    var scaleAnchor: UnitPoint {
        properties.contains(.position) ? .center : .topLeading
    }

    func save(frame: CGRect?) {
        if isSource, let frame = frame, namespace.sourceFrames[id] != frame {
            namespace.sourceFrames[id] = frame
            namespace.sourceAnchors[id] = anchor
        }
    }

    func scale(_ frame: CGRect?, progress: CGFloat) -> CGSize {
        guard
            !isSource,
            properties.contains(.size),
            let frame = frame,
            let sourceFrame = sourceFrame else {
                return CGSize(width: 1, height: 1)
        }

        let interpolatedSize = CGSize(
            width: progress * frame.width + (1 - progress) * sourceFrame.width,
            height: progress * frame.height + (1 - progress) * sourceFrame.height
        )

        return CGSize(
            width: frame.width == 0 ? 1 : interpolatedSize.width / frame.width,
            height: frame.height == 0 ? 1 : interpolatedSize.height / frame.height
        )
    }

    func offset(_ frame: CGRect?, progress: CGFloat) -> CGSize {
        guard
            !isSource,
            properties.contains(.position),
            let frame = frame,
            var sourceFrame = sourceFrame else {
                return .zero
        }

        if !properties.contains(.frame) {
            sourceFrame.size = frame.size
        }

        let interpolatedPoint = CGPoint(
            x: progress * frame.x(for: anchor) + (1 - progress) * sourceFrame.x(for: sourceAnchor),
            y: progress * frame.y(for: anchor) + (1 - progress) * sourceFrame.y(for: sourceAnchor)
        )

        return CGSize(
            width: (interpolatedPoint.x - frame.x(for: anchor)),
            height: (interpolatedPoint.y - frame.y(for: anchor))
        )
    }
}

extension CGRect {
    func x(for anchor: UnitPoint) -> CGFloat {
        minX + width * anchor.x
    }
    func y(for anchor: UnitPoint) -> CGFloat {
        minY + height * anchor.y
    }
}
