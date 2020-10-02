//
// GeometryConfig.swift
//  
// Created by Andreas in 2020
//

import SwiftUI

struct GeometryConfig<ID: Hashable>: Equatable {

    let id: ID
    let properties: MatchedGeometryProperties
    let anchor: UnitPoint
    let isSource: Bool
    let matching: GeometryMatching

    func update(frame: CGRect?) {
        guard isSource, let frame = frame else { return }
        matching.sources[id] = Geometry(frame: frame, anchor: anchor)
    }

    func change(for frame: CGRect?) -> GeometryChange {
        guard !isSource,
              let frame = frame,
              let source = matching.sources[id]
        else { return .zero }
        return GeometryChange(
            frame: frame,
            sourceFrame: source.frame,
            anchor: anchor,
            sourceAnchor: source.anchor,
            properties: properties
        )
    }

    func update(transitionFrame frame: CGRect?, uuid: UUID) {
        var geoDict = matching.transitions[id] ?? [:]
        guard isSource,
              let frame = frame,
              geoDict[uuid] == nil
        else { return }
        if geoDict.keys.count >= 2 && !geoDict.keys.contains(uuid) {
            // reset, because we have too many sources
            reset()
        }
        geoDict[uuid] = .init(frame: frame, anchor: anchor)
        matching.transitions[id] = geoDict
    }

    func transitionChange(for frame: CGRect?, uuid: UUID) -> GeometryChange {
        guard let dict = matching.transitions[id],
              let info = dict[uuid],
              let source = dict.first(where: { $0.key != uuid })?.value
        else { return .zero }
        return GeometryChange(
            frame: info.frame,
            sourceFrame: source.frame,
            anchor: info.anchor,
            sourceAnchor: source.anchor,
            properties: properties
        )
    }

    func reset() {
        matching.transitions[id] = [:]
    }
}
