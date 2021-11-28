//
//  Bus+StickyEvent.swift
//  RealEventsBus
//
//  Created by Daniele Margutti on 28/11/21.
//

import Foundation

// MARK: - Public BufferedEvent extension for Bus

public extension Bus where EventType: BufferedEvent {
    
    /// Registered a new observer for a `BufferedEvent`.
    ///
    /// - Parameters:
    ///   - observer: observer object instance.
    ///   - storage: storage where the bus is saved; `.default` if not passed.
    ///   - queue: queue in which the callback will be triggered, `.main` if not passed.
    ///   - callback: callback to trigger.
    static func register(_ observer: AnyObject, storage: BusStorage = .default,
                         queue: DispatchQueue = .main,
                         callback: @escaping EventCallback) {
        busForEventTypeIn(storage).register(observer, queue: queue, callback: callback)
    }
    
    /// Post a new event into the bus.
    ///
    /// - Parameters:
    ///   - event: event to post.
    ///   - storage: storage where the bus is saved, `.default` if not specified.
    static func post(_ event: EventType, storage: BusStorage = .default) {
        busForEventTypeIn(storage).post(event)
    }
    
    /// Return the last value buffered by the bus of this type.
    ///
    /// - Parameter storage: storage in which the bus is present, `.default` if not passed.
    /// - Returns: `EventType?`
    static func lastValue(storage: BusStorage = .default) -> EventType? {
        busForEventTypeIn(storage).lastValue
    }

}

// MARK: - Private BufferedEvent extension for Bus

fileprivate extension Bus where EventType: BufferedEvent {

    func register(_ observer: AnyObject,
                  queue: DispatchQueue,
                  callback: @escaping EventCallback) {
        let observer = EventObserver<EventType>(observer, queue, callback)
        observers.append(observer)
        
        if let lastValue = lastValue {
            observer.post(lastValue) // post the last value immediately.
        }
    }

    func post(_ event: EventType) {
        self.lastValue = event
        observers.forEach {
            $0.post(event)
        }
    }

}
