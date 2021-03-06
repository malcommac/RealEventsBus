//
//  EventObserver.swift
//  RealEventsBus
//
//  Created by Daniele Margutti on 28/11/21.
//

import Foundation

internal class EventObserver<EventType: AnyEvent> {
    
    // MARK: - Private Properties
    
    /// Callback to call when observer is triggered.
    typealias EventCallback = Bus<EventType>.EventCallback

    // MARK: - Private Properties
    
    /// The observer object itself. It's weakly referenced so we don't
    /// bother about memory issues.
    weak var observer: AnyObject?
    
    /// The pointer is used when you need to check the observer to remove.
    let observerRawPointer: UnsafeRawPointer
    
    /// Callback to call when the observer is triggered.
    let callback: EventCallback
    
    /// The name of the class of the event. This is used only for debug
    /// purpose in assertion failure case.
    let eventClassName: String
    
    /// Dispatch queue where the event should be called.
    let queue: DispatchQueue
    
    // MARK: - Initialization
    
    /// Initialize a new observer for a given object.
    ///
    /// - Parameters:
    ///   - observer: object to observe.
    ///   - queue: the dispatch queue in which the callback is triggered.
    ///   - callback: callback to call when observer is triggered.
    init(_ observer: AnyObject, _ queue: DispatchQueue, _ callback: @escaping EventCallback) {
        self.observer = observer
        self.observerRawPointer = UnsafeRawPointer(Unmanaged.passUnretained(observer).toOpaque())
        self.eventClassName = String(describing: observer)
        self.callback = callback
        self.queue = queue
    }
    
    // MARK: - Private Function
    
    func post(_ event: EventType) {
        guard observer != nil else {
            // No leak is generated but it could be great if you call `unregister()` on dealloc.
            assertionFailure("Observer for '\(eventClassName)' was deallocated without calling unregister()")
            return
        }
        
        queue.async { [weak self] in
            self?.callback(event)
        }
    }
    
}
