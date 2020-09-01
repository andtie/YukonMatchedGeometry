//
//  MatchedGeometryParameters.swift
//  
//
//  Created by Tielmann, Andreas on 15.07.2020.
//

import SwiftUI

struct MatchedGeometryParameters {

    let frame: CGRect
    let sourceFrame: CGRect
    let properties: MatchedGeometryProperties
    let anchor: UnitPoint
    let sourceAnchor: UnitPoint

    var scaleAnchor: UnitPoint {
        properties.contains(.position) ? .center : .topLeading
    }

    func scale(progress: CGFloat) -> CGSize {
        guard properties.contains(.size) else {
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

    func offset(progress: CGFloat) -> CGSize {
        guard properties.contains(.position) else {
            return .zero
        }

        var sourceFrame = self.sourceFrame
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

    static let zero = MatchedGeometryParameters(
        frame: .zero,
        sourceFrame: .zero,
        properties: [],
        anchor: .center,
        sourceAnchor: .center
    )
}

extension CGRect {
    func x(for anchor: UnitPoint) -> CGFloat {
        minX + width * anchor.x
    }
    func y(for anchor: UnitPoint) -> CGFloat {
        minY + height * anchor.y
    }
}
