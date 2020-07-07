//
//  View+MatchedGeometryEffect.swift
//  
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 07.07.2020.
//

import SwiftUI

extension View {
    public func matchedGeometryEffect<ID>(id: ID, in namespace: Namespace.ID, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) -> some View where ID: Hashable {
        modifier(
            MatchedGeometryModifier(
                config: MatchedGeometryConfig(
                    id: id,
                    namespace: namespace,
                    properties: properties,
                    anchor: anchor,
                    isSource: isSource
                )
            )
        )
    }
}
