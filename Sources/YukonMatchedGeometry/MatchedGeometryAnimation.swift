//
//  MatchedGeometryAnimation.swift
//
//
//  Created by Tielmann, Andreas on 14.07.2020.
//

import SwiftUI

struct MatchedGeometryAnimation<ID: Hashable>: AnimatableModifier {
    let config: MatchedGeometryConfig<ID>
    let frame: CGRect?
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        return content
            .scaleEffect(config.scale(frame, progress: progress), anchor: config.scaleAnchor)
            .offset(config.offset(frame, progress: progress))
    }
}
