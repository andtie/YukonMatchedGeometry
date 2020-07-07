//
//  MatchedGeometryProperties.swift
//  MatchedGeometry
//
//  Created by Tielmann, Andreas (DE - Duesseldorf) on 07.07.2020.
//  Copyright © 2020 Tielmann. All rights reserved.
//

import Foundation

public struct MatchedGeometryProperties: OptionSet {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    // TODO: compare with the rawValues in iOS 14

    /// The view's position, in window coordinates.
    public static let position = MatchedGeometryProperties(rawValue: 1 << 0)

    /// The view's size, in local coordinates.
    public static let size = MatchedGeometryProperties(rawValue: 1 << 1)

    /// Both the `position` and `size` properties.
    public static let frame: MatchedGeometryProperties = [.position, .size]

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = MatchedGeometryProperties

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = MatchedGeometryProperties

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = UInt32
}
