//
//  MatchedGeometryModifier.swift
//  MatchedGeometry
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 06.07.2020.
//  Copyright © 2020 Tielmann. All rights reserved.
//

import SwiftUI

struct MatchedGeometryModifier<ID: Hashable>: ViewModifier {

    let config: MatchedGeometryConfig<ID>

    @State var frame: CGRect?

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: MatchedGeometryPreference.self,
                        value: [self.config.id: proxy.frame(in: .global)]
                    )
                }
                .onPreferenceChange(MatchedGeometryPreference.self) { value in
                    self.frame = value[self.config.id]
                    if self.config.isSource {
                        MatchedGeometryPreference.reduce(
                            value: &self.config.namespace.value,
                            nextValue: { value }
                        )
                    }
                }
            )
            .transition(
                AnyTransition
                    .modifier(
                        active: MatchedGeometryEffect(
                            config: config,
                            frame: frame,
                            progress: 0
                        ).ignoredByLayout(),
                        identity: MatchedGeometryEffect(
                            config: config,
                            frame: frame,
                            progress: 1
                        ).ignoredByLayout()
                    )
                    .combined(with: AnyTransition.opacity)
            )
    }
}
