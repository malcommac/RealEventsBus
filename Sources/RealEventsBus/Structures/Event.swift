//
//  Event.swift
//  RealEventsBus
//
//  Created by Daniele Margutti on 28/11/21.
//

import Foundation

/// Type-erased protocol which define an event.
public protocol AnyEvent { }

/// The base type of an event.
public protocol Event: AnyEvent { }

/// Buffered event allows you to query for
/// the last value posted even outside the bus callback.
public protocol BufferedEvent: AnyEvent { }
