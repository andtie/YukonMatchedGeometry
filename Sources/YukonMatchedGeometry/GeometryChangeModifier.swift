//
// GeometryChangeModifier.swift
//
// Created by Andreas in 2020
//

import SwiftUI

struct GeometryChangeModifier: AnimatableModifier {

    var progress: CGFloat
    let currentChange: () -> GeometryChange

    init(_ currentChange: @escaping () -> GeometryChange, progress: CGFloat) {
        self.currentChange = currentChange
        self.progress = progress
    }

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        let change = currentChange()
        return content
            .scaleEffect(change.scale(progress), anchor: change.scaleAnchor)
            .offset(change.offset(progress))
    }
}
