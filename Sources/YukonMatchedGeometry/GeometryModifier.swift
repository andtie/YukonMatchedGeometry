//
// GeometryModifier.swift
//
// Created by Andreas in 2020
//

import SwiftUI

struct GeometryModifier<ID: Hashable>: ViewModifier {

    /// The current config, directly set
    var newConfig: GeometryConfig<ID>
    /// The old config, saved in a @State. May differ during animation.
    @State var oldConfig: GeometryConfig<ID>
    /// The current frame, as read by the GeometryReader.
    @State private var frame: CGRect?
    /// A unique id to identify the view in the shared namespace
    @State private var uuid = UUID()

    init(_ config: GeometryConfig<ID>) {
        newConfig = config
        _oldConfig = State(wrappedValue: config)
    }

    func body(content: Content) -> some View {
        content
            .modifier(GeometryChangeModifier(change(for: newConfig), progress: hasChanged ? 0 : 1))
            .modifier(GeometryChangeModifier(change(for: oldConfig), progress: hasChanged ? 1 : 0))
            .transition(
                AnyTransition.modifier(
                    active: GeometryChangeModifier(transitionChange, progress: 0),
                    identity: GeometryChangeModifier(transitionChange, progress: 1)
                )
                .combined(with: .opacity)
            )
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: GeometryPreference.self,
                        value: proxy.frame(in: .global)
                    )
                }
                .onPreferenceChange(GeometryPreference.self) { value in
                    self.frame = value
                }
            )
            .onAppear { newConfig.reset() }
            .onDisappear { newConfig.reset() }
    }

    var hasChanged: Bool {
        newConfig != oldConfig
    }

    func change(for config: GeometryConfig<ID>) -> () -> GeometryChange {
        config.update(frame: frame)
        return { config.change(for: self.frame) }
    }

    func transitionChange() -> GeometryChange {
        newConfig.update(transitionFrame: frame, uuid: uuid)
        return newConfig.transitionChange(for: frame, uuid: uuid)
    }
}

private struct GeometryPreference: PreferenceKey {

    typealias Value = CGRect?

    static var defaultValue: Value = nil

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
