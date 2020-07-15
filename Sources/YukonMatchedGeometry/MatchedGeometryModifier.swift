//
//  MatchedGeometryModifier.swift
//
//
//  Created by Tielmann, Andreas on 06.07.2020.
//

import SwiftUI

struct MatchedGeometryModifier<ID: Hashable>: ViewModifier {

    /// The current config, directly set
    var newConfig: MatchedGeometryConfig<ID>
    /// The old config, saved in a @State. May differ during animation.
    @State var oldConfig: MatchedGeometryConfig<ID>
    /// The current frame, as read by the GeometryReader.
    @State private var frame: CGRect?

    func params(_ config: MatchedGeometryConfig<ID>) -> () -> MatchedGeometryParameters? {
        /// we return a function s.t. the frame lookups occur at time of use
        func wrapped() -> MatchedGeometryParameters? {
            config.parameters(for: self.frame)
        }
        return wrapped
    }

    func body(content: Content) -> some View {
        newConfig.save(frame: frame)
        let hasChanged = newConfig != oldConfig
        return content
            .modifier(MatchedGeometryAnimation(params: params(newConfig), progress: hasChanged ? 0 : 1))
            .modifier(MatchedGeometryAnimation(params: params(oldConfig), progress: hasChanged ? 1 : 0))
            .transition(
                .modifier(
                    active: MatchedGeometryAnimation(params: params(newConfig), progress: 0),
                    identity: MatchedGeometryAnimation(params: params(newConfig), progress: 1)
                )
            )
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: MatchedGeometryPreference.self,
                        value: proxy.frame(in: .global)
                    )
                }
                .onPreferenceChange(MatchedGeometryPreference.self) { value in
                    self.frame = value
                }
            )
    }
}
