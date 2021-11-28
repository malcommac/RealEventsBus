//
//  Bus+EventType.swift
//  RealEventsBus
//
//  Created by Daniele Margutti on 28/11/21.
//

import Foundation

public extension Bus where EventType: Event {
    
    // MARK: - Public Functions
    
    /// Post a new event into the bus.
    ///
    /// - Parameters:
    ///   - event: event to post.
    ///   - storage: storage destination, `.default` if none.
    static func post(_ event: EventType, storage: BusStorage = .default) {
        busForEventTypeIn(storage).post(event)
    }
    
    /// Register a new observer to receive events from this bus type.
    ///
    /// - Parameters:
    ///   - observer: observer instance.
    ///   - store: storage to use, `.default` if not specified.
    ///   - queue: dispatch queue where the message must be delivered, `.main` if not specified.
    ///   - callback: callback to execute when event is received.
    static func register(_ observer: AnyObject,
                         storage: BusStorage = .default,
                         queue: DispatchQueue = .main,
                         _ callback: @escaping EventCallback) {
        busForEventTypeIn(storage).register(observer, queue: queue, callback: callback)
    }
    
    // MARK: - Private Functions
    
    /// Create a new listener for a new observer to register and add to the list of observers for this bus.
    ///
    /// - Parameters:
    ///   - observer: observer to register.
    ///   - queue: queue in which the callback should be executed.
    ///   - callback: callback to execute.
    private func register(_ observer: AnyObject, queue: DispatchQueue, callback: @escaping EventCallback) {
        let observer = EventObserver<EventType>(observer, queue, callback)
        observers.append(observer)
    }
    
    /// This notify all the observers about a new incoming event.
    ///
    /// - Parameter event: event arrived.
    private func post(_ event: EventType) {
        observers.forEach {
            $0.post(event)
        }
    }

}
