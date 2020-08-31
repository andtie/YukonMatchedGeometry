//
//  View+MatchedGeometryEffect.swift
//  
//
//  Created by Tielmann, Andreas on 07.07.2020.
//

import SwiftUI

extension View {
    public func matchedGeometryEffect<ID>(id: ID, in namespace: Namespace.ID, guid: String? = nil, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) -> some View where ID: Hashable {
        let config = MatchedGeometryConfig(
            id: id,
            namespace: namespace,
            properties: properties,
            anchor: anchor,
            isSource: isSource
        )
        return modifier(MatchedGeometryModifier(newConfig: config, oldConfig: config))
    }
}

@available(iOS 14.0, *)
extension View {
    public func matchedGeometryEffect<ID>(id: ID, in namespace: SwiftUI.Namespace.ID, guid: String? = nil, properties: SwiftUI.MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) -> some View where ID: Hashable {
        matchedGeometryEffect(id: id, in: namespace, properties: properties, anchor: anchor, isSource: isSource)
    }
}
