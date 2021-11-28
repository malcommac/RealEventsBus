# RealEventsBus

RealEventsBus is a small swift package which implement a basic event bus mechanism.  
You can use it as a dispatcher for one-to-many events. It's like `NSNotification` but with type-safe support.

## Highlights

- It's type safe; you can send message in a type-safe manner
- Implement custom messages; just set conformance to `Event` or `BufferedEvent` type
- Messages/observers are posted and registered in thread safe
- Easy to use; just one line to register and post events
- Supports for buffered events

## 1. Example

This example uses `enum` as datatype for event.  You can use any type you want as event, `struct` or `class`.
First of all we need to define a list of events:

```swift
public enum UserEvents: Event {
    case userDidLogged(username: String)
    case userLoggedOut
    case profileUpdated(fullName: String, age: Int)
}
```

Suppose you want to be notified about this kind of events in your `UIViewController`:

```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        Bus<UserEvents>.register(self) { event in
            switch event {
            case .profileUpdated(let fullName, let age):
                print("Profile updated with '\(fullName)', which is \(age) old")
            case .userDidLogged(let username):
                print("User '\(username)' logged in")
            case .userLoggedOut:
                print("User logged out")
            }
        }
    }

    deinit {
        // While it's not required (it does not generate any leak) 
        // you may want to unregister an observer when it's not needed anymore.
        Bus<UserEvents>.unregister(self)
    }
}
```

When you need to post new events to any registered obserer like the one above just use `post` function:

```swift
Bus<UserEvents>.post(.userDidLogged(username: "danielemm"))
```

## BufferedEvent

If your event is conform to `BufferedEvent` instead of `Event` you can use the `lastValue()` function to get the latest posted value into the bus.  
Moreover: when a new observer is registered it will receive the last value posted into the bus, if any.

This is an example.

First of all we define the message:

```swift
public class CustomEvent: BufferedEvent {
    
    var messageValue: String
    var options: [String: Any?]?
    
    public init(value: String, options: [String: Any?]) {
        self.messageValue = value
        self.options = options
    }

}
```

```swift
    // Post a new event
    Bus<CustomEvent>.post(.init(value: "Some message", options: ["a": 1, "b": "some"]))

    // At certain point in your code:
    let lastValue = Bus<CustomEvent>.lastValue() // print the type above!
```

## Queue

You can also specify a queue where the message callback will be called.  
By default the `.main` queue is used.

```swift
Bus<CustomEvent>.register(self, queue: .global()) { _ in // in background queue
   // do something
}        
```

## Swift Package Manager

To install it using the Swift Package Manager, either directly add it to your project using Xcode 11, or specify it as dependency in the Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/malcommac/RealEventsBus.git", branch: "main"),
],
```