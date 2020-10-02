//
// Namespace.swift
// 
// Created by Andreas in 2020
//

import Foundation

@propertyWrapper public struct Namespace {
    public typealias ID = GeometryMatchingWithFallback
    public let wrappedValue = ID()
    public init() {}
}

/// Use this namespace if you do **not** want to use the SwiftUI implementation even on iOS 14.
@propertyWrapper public struct YukonNamespace {
    public typealias ID = GeometryMatching
    public let wrappedValue = ID()
    public init() {}
}
