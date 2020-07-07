//
//  MatchedGeometryConfig.swift
//  
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 07.07.2020.
//

import SwiftUI

struct MatchedGeometryConfig<ID: Hashable> {
    let id: ID
    let namespace: Namespace.ID
    let properties: MatchedGeometryProperties
    let anchor: UnitPoint
    let isSource: Bool
}
