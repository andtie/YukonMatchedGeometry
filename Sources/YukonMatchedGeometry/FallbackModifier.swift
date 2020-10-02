//
// FallbackModifier.swift
//
// Created by Andreas in 2020
//

import SwiftUI

@available(iOS 14.0, *)
struct FallbackModifier<ID: Hashable>: ViewModifier {
    @SwiftUI.Namespace var _namespace

    let id: ID
    let namespace: Namespace.ID
    let properties: MatchedGeometryProperties
    let anchor: UnitPoint
    let isSource: Bool

    @ViewBuilder func body(content: Content) -> some View {
        if let namespaceId = namespace.id(default: _namespace) {
            content
                .matchedGeometryEffect(id: id, in: namespaceId, properties: .init(rawValue: properties.rawValue), anchor: anchor, isSource: isSource)
        } else {
            // if _namespace is already used, we go one lvel deeper to create a new namespace
            content
                .modifier(FallbackModifier(id: id, namespace: namespace, properties: properties, anchor: anchor, isSource: isSource))
        }
    }
}
