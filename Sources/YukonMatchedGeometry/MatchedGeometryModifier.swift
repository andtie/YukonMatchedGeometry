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
    /// A unique id to identify the view in the shared namespace
    @State private var uuid = UUID()

    func body(content: Content) -> some View {
        content
            .modifier(MatchedGeometryAnimation(progress: hasChanged ? 0 : 1, parameters: parameters(config: newConfig)))
            .modifier(MatchedGeometryAnimation(progress: hasChanged ? 1 : 0, parameters: parameters(config: oldConfig)))
            .transition(
                AnyTransition.opacity.combined(
                    with:
                        AnyTransition.asymmetric(
                            insertion: .modifier(
                                active: MatchedGeometryAnimation(progress: 0, parameters: transitionParams),
                                identity: MatchedGeometryAnimation(progress: 1, parameters: transitionParams)
                            ),
                            removal: .modifier(
                                active: MatchedGeometryAnimation(progress: 0, parameters: transitionParams),
                                identity: MatchedGeometryAnimation(progress: 1, parameters: transitionParams)
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
            .onAppear {
                resetInsertion()
            }
            .onDisappear {
                resetInsertion()
            }
    }

    var hasChanged: Bool {
        newConfig != oldConfig
    }

    func resetInsertion() {
        newConfig.namespace.insertionFrames[self.newConfig.id] = [:]
        newConfig.namespace.insertionAnchors[self.newConfig.id] = [:]
    }

    func parameters(config: MatchedGeometryConfig<ID>) -> () -> MatchedGeometryParameters? {
        config.save(frame: frame)

        func parameters() -> MatchedGeometryParameters? {
            config.parameters(for: frame)
        }
        return parameters
    }

    func transitionParams() -> MatchedGeometryParameters? {
        newConfig.save(insertionFrame: frame, uuid: uuid)
        return newConfig.transitionParameters(for: frame, uuid: uuid)
    }
}
