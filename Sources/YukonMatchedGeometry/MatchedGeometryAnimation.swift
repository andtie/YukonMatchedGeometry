//
//  MatchedGeometryAnimation.swift
//
//
//  Created by Tielmann, Andreas on 14.07.2020.
//

import SwiftUI

struct MatchedGeometryAnimation: AnimatableModifier {

    var progress: CGFloat
    let parameters: () -> MatchedGeometryParameters

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(
                parameters().scale(progress: progress),
                anchor: parameters().scaleAnchor
            )
            .offset(parameters().offset(progress: progress))
    }
}
