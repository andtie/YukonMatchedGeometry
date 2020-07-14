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

    func body(content: Content) -> some View {
        newConfig.save(frame: frame)
        return content
            .modifier(MatchedGeometryAnimation(config: newConfig, frame: frame, progress: newConfig == oldConfig ? 1 : 0))
            .modifier(MatchedGeometryAnimation(config: oldConfig, frame: frame, progress: newConfig == oldConfig ? 0 : 1))
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: MatchedGeometryPreference.self,
                        value: proxy.frame(in: .global)
                    )
                }
                .onPreferenceChange(MatchedGeometryPreference.self) { value in
                    self.frame = value
                    self.newConfig.save(frame: value)
                }
            )
    }
}
