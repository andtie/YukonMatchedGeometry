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
        let hasChanged = newConfig != oldConfig
        let transitionParams = self.transitionParams()
        return content
            .modifier(MatchedGeometryAnimation(type: .default, params: params(newConfig), progress: hasChanged ? 0 : 1))
            .modifier(MatchedGeometryAnimation(type: .default, params: params(oldConfig), progress: hasChanged ? 1 : 0))
            .transition(
                AnyTransition.opacity.combined(with:
                    AnyTransition.asymmetric(
                        insertion: .modifier(
                            active: MatchedGeometryAnimation(type: .insertionActive, params: transitionParams, progress: 0),
                            identity: MatchedGeometryAnimation(type: .insertionIdentity, params: transitionParams, progress: 1)
                        ),
                        removal: .modifier(
                            active: MatchedGeometryAnimation(type: .removalActive, params: transitionParams, progress: 0),
                            identity: MatchedGeometryAnimation(type: .removalIdentity, params: transitionParams, progress: 1)
                        )
                    )
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
            .onDisappear {
                self.newConfig.namespace.insertionFrames[self.newConfig.id] = [:]
                self.newConfig.namespace.insertionAnchors[self.newConfig.id] = [:]
            }
    }

    func params(_ config: MatchedGeometryConfig<ID>) -> (Bool) -> MatchedGeometryParameters? {
        /// we return a function s.t. the frame lookups occur at time of use
        func wrapped(isRemoved: Bool) -> MatchedGeometryParameters? {
            config.parameters(for: frame)
        }
        return wrapped
    }

    func transitionParams() -> (Bool) -> MatchedGeometryParameters? {
        /// we return a function s.t. the frame lookups occur at time of use
        func wrapped(isRemoved: Bool) -> MatchedGeometryParameters? {
            newConfig.save(transitionFrame: frame, key: isRemoved)
            return newConfig.transitionParameters(for: frame, key: isRemoved)
        }
        return wrapped
    }
}
