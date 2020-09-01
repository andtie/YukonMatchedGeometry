//
//  MatchedGeometryAnimation.swift
//
//
//  Created by Tielmann, Andreas on 14.07.2020.
//

import SwiftUI

struct MatchedGeometryAnimation: AnimatableModifier {

    var progress: CGFloat
    let parameters: () -> MatchedGeometryParameters?

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    var params: MatchedGeometryParameters? {
        parameters()
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(
                params?.scale(progress: progress) ?? CGSize(width: 1, height: 1),
                anchor: params?.scaleAnchor ?? .center
            )
            .offset(params?.offset(progress: progress) ?? .zero)
    }
}
