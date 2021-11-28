//
//  Atomic.swift
//  RealEventsBus
//
//  Created by Daniele Margutti on 23/11/21.
//

import Foundation

/// This property wrapper allows you to define an atomic access for a given property.
@propertyWrapper
internal struct AtomicValue<Value> {

    // MARK: - Private Properties
    
    /// Value hold.
    private var value: Value
    
    /// Lock mechanism.
    private let lock = NSLock()

    // MARK: - Initialization
    
    /// Initialize a new atomic container for a given property.
    ///
    /// - Parameter value: property value.
    init(wrappedValue value: Value) {
        self.value = value
    }
    
    // MARK: - Property Wrapper Methods
    
    var wrappedValue: Value {
        get { return load() }
        set { store(newValue: newValue) }
    }
    
    func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
    
    mutating func store(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
    
}
