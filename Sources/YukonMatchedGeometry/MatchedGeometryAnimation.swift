//
//  MatchedGeometryAnimation.swift
//
//
//  Created by Tielmann, Andreas on 14.07.2020.
//

import SwiftUI

struct MatchedGeometryAnimation: AnimatableModifier {

    @State var isRemoved: Bool = false

    let type: AnimationTypePreference.AnimationType
    let params: (Bool) -> MatchedGeometryParameters?
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        let params = self.params(isRemoved)
        return content
            .scaleEffect(
                params?.scale(progress: progress) ?? CGSize(width: 1, height: 1),
                anchor: params?.scaleAnchor ?? .center
            )
            .offset(params?.offset(progress: progress) ?? .zero)
            .preference(key: AnimationTypePreference.self, value: type)
            .onPreferenceChange(AnimationTypePreference.self) { value in
                if value == .removalActive {
                    self.isRemoved = true
                }
            }
    }
}

struct AnimationTypePreference: PreferenceKey {

    enum AnimationType: Equatable {
        case `default`, insertionActive, insertionIdentity, removalActive, removalIdentity
    }

    typealias Value = AnimationType

    static var defaultValue: Value = .default

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
