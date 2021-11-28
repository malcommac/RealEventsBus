//
//  BusStorage.swift
//  RealEventsBus
//
//  Created by Daniele Margutti on 28/11/21.
//

import Foundation

/// The bus storage is used to keep the list of registered buses
/// for event types along their observers. Typically you don't need
/// to use custom store, but the library allows you to keep it so
/// you can better manage custom needs.
public class BusStorage {
    
    // MARK: - Public Properties

    /// The default bus storage.
    static public let `default` = BusStorage()

    // MARK: - Private Properties
    
    @AtomicValue
    /// The list of registered buses (as type-erased) in the storage.
    internal var buses = [AnyBus]()
    
    // MARK: - Initialization
    
    /// Initialize a new storage.
    public init() {
        
    }
    
    // MARK: - Private Functions
    
    /// Get the bus instance for a specified event type currently hold by the storage.
    ///
    /// - Returns: `Bus<EventType>?`
    internal func buseForEventType<EventType: AnyEvent>() -> Bus<EventType>? {
        for case let subscriber as Bus<EventType> in buses {
            return subscriber
        }
        
        return nil
    }
    
}
