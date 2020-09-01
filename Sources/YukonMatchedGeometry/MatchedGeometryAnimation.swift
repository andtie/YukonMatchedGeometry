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
        let params = parameters()
        return content
            .scaleEffect(
                params.scale(progress: progress),
                anchor: params.scaleAnchor
            )
            .offset(params.offset(progress: progress))
    }
}
