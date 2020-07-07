//
//  MatchedGeometryEffect.swift
//  MatchedGeometry
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 07.07.2020.
//  Copyright © 2020 Tielmann. All rights reserved.
//

import SwiftUI

struct MatchedGeometryEffect<ID: Hashable>: GeometryEffect {

    let config: MatchedGeometryConfig<ID>
    let frame: CGRect?

    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        guard
            let myFrame = frame,
            let otherFrame = config.namespace.value[config.id] else {
                return ProjectionTransform()
        }

        let interpolatedSize = CGSize(
            width: progress * myFrame.width + (1 - progress) * otherFrame.width,
            height: progress * myFrame.height + (1 - progress) * otherFrame.height
        )

        let scale = CGPoint(
            x: myFrame.width == 0 ? 1 : interpolatedSize.width / myFrame.width,
            y: myFrame.height == 0 ? 1 : interpolatedSize.height / myFrame.height
        )

        let interpolatedCenter = CGPoint(
            x: progress * myFrame.midX + (1 - progress) * otherFrame.midX,
            y: progress * myFrame.midY + (1 - progress) * otherFrame.midY
        )

        let offset = CGPoint(
            x: (interpolatedCenter.x - myFrame.midX),
            y: (interpolatedCenter.y - myFrame.midY)
        )

        var transform = CGAffineTransform.identity

        if config.properties.contains(.position) {
            transform = transform.translatedBy(x: offset.x, y: offset.y)
        }

        if config.properties.contains(.size) {
            transform = transform
                .translatedBy(x: myFrame.width / 2, y: myFrame.height / 2)
                .scaledBy(x: scale.x, y: scale.y)
                .translatedBy(x: -myFrame.width / 2, y: -myFrame.height / 2)
        }

        return ProjectionTransform(transform)
    }
}
