//
// View+MatchedGeometryEffect.swift
//  
// Created by Andreas in 2020
//

import SwiftUI

extension View {
    /// A reimplementation of SwiftUIs MatchedGeometryEffect.
    public func matchedGeometryEffect<ID>(id: ID, in namespace: YukonNamespace.ID, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) -> some View where ID: Hashable {
        modifier(GeometryModifier(GeometryConfig(id: id, properties: properties, anchor: anchor, isSource: isSource, matching: namespace)))
    }

    /// On iOS 14, this function falls back to the SwiftUI implementation.
    @ViewBuilder
    public func matchedGeometryEffect<ID>(id: ID, in namespace: Namespace.ID, properties: MatchedGeometryProperties = .frame, anchor: UnitPoint = .center, isSource: Bool = true) -> some View where ID: Hashable {
        if #available(iOS 14, *) {
            modifier(FallbackModifier(id: id, namespace: namespace, properties: properties, anchor: anchor, isSource: isSource))
        } else {
            modifier(GeometryModifier(GeometryConfig(id: id, properties: properties, anchor: anchor, isSource: isSource, matching: namespace)))
        }
    }
}
