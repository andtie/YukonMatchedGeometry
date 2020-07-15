//
//  MatchedGeometryAnimation.swift
//
//
//  Created by Tielmann, Andreas on 14.07.2020.
//

import SwiftUI

struct MatchedGeometryAnimation: AnimatableModifier {
    let params: () -> MatchedGeometryParameters?
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        let params = self.params()
        return content
            .scaleEffect(
                params?.scale(progress: progress) ?? CGSize(width: 1, height: 1),
                anchor: params?.scaleAnchor ?? .center
            )
            .offset(params?.offset(progress: progress) ?? .zero)
//            .opacity(isTransition ? Double(progress) : 1)
    }
}
