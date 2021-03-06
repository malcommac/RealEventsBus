//
//  Messenger.swift
//  RealEventsBus
//
//  Created by Daniele Margutti on 20/11/21.
//

import Foundation

/// Type erased protocol for bus related classes.
public protocol AnyBus { } 

/// The bus class is used to carry out events to the registered observers.
/// When a bus is created is registered inside a `BusStorage`; if you don't want
/// to specify a bus storage you can use the default (`.default`).
public class Bus<EventType: AnyEvent>: AnyBus {
    
    /// Defines the callback which is called for an event.
    public typealias EventCallback = (_ event: EventType) -> Void

    // MARK: - Public Properties
    
    /// Last value posted; it may be filled only for `BufferedEvent` even types.
    @AtomicValue
    internal var lastValue: EventType?
    
    // MARK: - Private Properties
    
    /// List of observers registered for this bus.
    internal var observers = SynchronizedArray<EventObserver<EventType>>()
    
    // MARK: - Public Functions
    
    /// Return or create (if not exists) a bus for a given `EventType` inside
    /// the storage class you have specified.
    ///
    /// - Parameter storage: storage where the bus is get or created.
    /// - Returns: `Bus<EventType>`
    static func busForEventTypeIn(_ storage: BusStorage) -> Bus<EventType> {
        if let bus: Bus<EventType> = storage.buseForEventType() {
            return bus // use the existing bus
        }
        
        // Create a new bus
        let bus = Bus<EventType>()
        storage.buses.append(bus)
        return bus
    }
    
}


// MARK: - Public Extensions

/// This defines a list of events which are not related to the `EventType` passed
/// to create an object.
extension Bus {
    
    /// Unregister an observer instance from the passed store.
    ///
    /// - Parameters:
    ///   - observer: observer instance you want to unregister.
    ///   - storage: storage instance.
    public static func unregister(_ observer: AnyObject?, storage: BusStorage = .default) {
        busForEventTypeIn(storage).unregister(observer: observer)
    }
    
    // MARK: - Private Functions
    
    /// Unregister given observer from self.
    ///
    /// - Parameter observer: observer to unregister, if `nil` nothing is done.
    fileprivate func unregister(observer: AnyObject?) {
        guard let observer = observer else {
            return
        }
        
        let rawPointer = UnsafeRawPointer(Unmanaged.passUnretained(observer).toOpaque())
        let newListeners = observers.filter {
            $0.observerRawPointer != rawPointer // remove observer which points to deallocated object.
        }
        self.observers = newListeners
    }
    
}
