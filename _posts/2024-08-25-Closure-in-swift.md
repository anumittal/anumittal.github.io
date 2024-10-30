---
layout: post
title: Closure in iOS
date: '2024-08-25T1:30:00.001-07:00'
author: Anu Mittal
categories: 'anu'
subclass: post
tags:
- Tech 
- Swift
---

# **The Evolution of Closures in iOS Development**

## **1. Introduction**

In the realm of programming, closures have long been a powerful tool, particularly in managing asynchronous operations. A closure is a self-contained block of functionality that can capture and store references to variables from the context in which it was created. This ability makes closures particularly useful in asynchronous programming, where operations often need to be executed out of order or in the background.

Check out the offical definition of closure in the reference links below. These have great examples of various closure expression syntax and do read about the [trailing closure](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures/#Trailing-Closures)


It is also important to know the use of [escaping](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures/#Escaping-Closures) and non-escaping closures.

### References:
- [Swift Documentation: Closures](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures/)
- [Apple Developer: Blocks Programming Topics](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Blocks/Articles/00_Introduction.html)

## **2. Closures in Objective-C**

Before Swift, Objective-C used blocks, which were similar to closures. Blocks allowed developers to encapsulate functionality and pass it around, but their syntax was often considered cumbersome.

### Example of a Block in Objective-C:
```objc
void (^simpleBlock)(void) = ^{
    NSLog(@"This is a simple block");
};
```

In this code:
- **Block Definition:** The block is defined as a variable `simpleBlock` that takes no parameters and returns nothing (`void`).
- **Block Syntax:** The syntax involves declaring the block type with `^`, followed by the block’s implementation within `^{}`.
- **Execution:** To execute the block, you would simply call `simpleBlock()`.

This block would print "This is a simple block" to the console when executed. You can find more examples and use cases of blocks in Objc [here](https://anumittal.in/Blocks-in-ObjectiveC). However, the syntax was more verbose compared to what you would later experience with Swift's closures.

### References:
- [Apple Developer: Working with Blocks](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithBlocks/WorkingwithBlocks.html)

## **3. Basic Closure Syntax in Swift**

```swift
let greet = { (name: String) -> String in
    return "Hello, \(name)!"
}
```

In this example:
- **Closure Definition:** The closure is assigned to a variable `greet`.
- **Parameters and Return Type:** The closure takes a `String` parameter named `name` and returns a `String`.
- **Closure Body:** The body of the closure contains the logic, which in this case, is to return a greeting message.

This closure can be called like a function:
```swift
let message = greet("Anu")
// message = "Hello, Anu!"
```

Compared to Objective-C blocks, Swift's closures are easier to write and read, allowing developers to use them more frequently and effectively.

### References:
- [Swift Evolution: SE-0002 Removing currying `func` declaration syntax](https://github.com/apple/swift-evolution/blob/master/proposals/0002-remove-currying.md)

## **4. Closures and Delegates for Asynchronous Programming in iOS**

Both closures and delegates have played crucial roles in asynchronous programming in iOS. While closures offer a straightforward way to handle asynchronous tasks, delegates provide a more structured approach, especially when multiple related methods are involved.

### **4.1 Completion Handler Pattern**

Completion handlers, implemented using closures, became a common pattern for handling asynchronous operations in iOS development. They allow developers to perform an action when an asynchronous task completes.

### Example:
```swift
func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
    // Simulate an asynchronous operation
    DispatchQueue.global().async {
        let data = Data() // Simulated fetched data
        // Call the completion handler with the result on the main thread
        DispatchQueue.main.async {
            completion(.success(data))
        }
    }
}
```

In this example:
- **Function Definition:** The function `fetchData` takes a closure named `completion` as a parameter. This closure is marked with `@escaping` because it will be executed after the function returns, making it an escaping closure.
- **Asynchronous Operation:** Inside the function, an asynchronous task is simulated using `DispatchQueue.global().async`, which runs on a background thread.
- **Completion Handler:** Once the background task is completed, the completion handler closure is called on the main thread to update the UI or perform further actions.

This pattern was widely used before the introduction of **async/await**, allowing developers to handle asynchronous tasks without blocking the main thread.

### **4.2 Grand Central Dispatch (GCD) and Closures**

GCD, combined with closures, provided a powerful way to manage concurrent operations in iOS apps. GCD allows tasks to be dispatched to different queues, and closures are used to define what those tasks should do.

### Example:
```swift
DispatchQueue.global().async {
    // Perform a time-consuming task in the background
    let result = heavyComputation()
    
    DispatchQueue.main.async {
        // Update the UI on the main thread with the result
        updateUI(with: result)
    }
}
```

In this example:
- **Background Task:** A closure is passed to `DispatchQueue.global().async`, which runs the closure on a background thread. This is where you would perform a heavy computation that shouldn’t block the main thread.
- **UI Update:** After the background task completes, another closure is passed to `DispatchQueue.main.async` to update the UI on the main thread with the result of the computation.

This pattern allowed developers to keep their apps responsive by offloading time-consuming tasks to background threads while still updating the UI seamlessly.

### **4.3 Delegates in Asynchronous Programming**

Before closures became widespread, delegates were the primary method for handling asynchronous tasks and events in iOS. A delegate is an object that acts on behalf of, or in coordination with, another object when an event occurs. Delegates are often used in scenarios where multiple methods are needed to handle different aspects of a process, such as managing a download session.

### Example:
```swift
protocol DownloadDelegate: AnyObject {
    func downloadDidStart()
    func downloadDidFinish(data: Data)
    func downloadDidFail(error: Error)
}

class DownloadManager {
    weak var delegate: DownloadDelegate?
    
    func startDownload() {
        delegate?.downloadDidStart()
        
        // Simulate an asynchronous download
        DispatchQueue.global().async {
            let data = Data() // Simulated download data
            DispatchQueue.main.async {
                self.delegate?.downloadDidFinish(data: data)
            }
        }
    }
}
```

In this example:
- **Protocol Definition:** The `DownloadDelegate` protocol defines methods that handle different stages of a download.
- **Delegate Property:** The `DownloadManager` class has a `delegate` property, which is used to notify the delegate of various events.
- **Delegate Method Calls:** The `startDownload` method simulates a download process and calls the appropriate delegate methods based on the outcome.

Delegates provide a clear and organized way to manage complex processes where multiple related events need to be handled.

### **4.4 Combine Framework and Closures**

The Combine framework, introduced in iOS 13, uses closures extensively for declarative, reactive programming. Combine allows developers to process asynchronous events over time, and closures are used to handle events such as receiving values or completions.

### Example:
```swift
cancellable = publisher
    .sink(receiveCompletion: { completion in
        // Handle the completion event
        switch completion {
        case .finished:
            print("Completed successfully")
        case .failure(let error):
            print("Failed with error: \(error)")
        }
    }, receiveValue: { value in
        // Handle each received value
        print("Received value: \(value)")
    })
```

In this example:
- **Sink Operator:** The `sink` operator is used to subscribe to the publisher. It takes two closures: one for handling completion and another for handling each received value.
- **Completion Handling:** The first closure processes the completion event, checking whether the stream finished successfully or encountered an error.
- **Value Handling:** The second closure processes each value received from the publisher.

Combine’s declarative syntax, combined with closures, offers a more modern approach to handling asynchronous data streams compared to the imperative style of GCD.

### **4.5 Async/Await in Swift and Closures**

Swift 5.5 introduced async/await, providing a more straightforward way to write asynchronous code. This syntax abstracts away much of the complexity associated with closures, allowing developers to write asynchronous code that looks and behaves like synchronous code.

### Example:
```swift
func fetchUserData() async throws -> UserData {
    let data = try await networkService.fetchData()
    return try JSONDecoder().decode(UserData.self, from: data)
}
```

In this example:
- **Async Function:** The function `fetchUserData` is marked with `async` and `throws`, indicating that it performs an asynchronous task and might throw an error.
- **Await Keyword:** The `await` keyword is used to pause the execution of the function until the asynchronous task completes, making the code more readable and easier to understand.

By eliminating the need for explicit completion handlers, async/await simplifies the management of asynchronous code. However, closures still power much of the async/await machinery behind the scenes, maintaining their importance in the language’s concurrency model.

### References:
- [Apple Developer: Concurrency](https://developer.apple.com/documentation/swift/concurrency)
- [WWDC 2021: Meet async/await in Swift](https://developer.apple.com/videos/play/wwdc2021/10132/)

## **5. Modern Uses of Closures and Delegates in iOS Development**

Both closures and delegates continue to play essential roles in modern iOS development, particularly in SwiftUI, contemporary UIKit patterns, and scenarios requiring complex event handling.

### **5.1 SwiftUI and Closures**

SwiftUI relies heavily on closures to define the behavior of UI components, making code more concise and readable.

### SwiftUI Example:
```swift
Button(action: {
    // Button action
    print("Button tapped")
}) {
    Text("Tap me")
}
```

In this SwiftUI example:
- **Button Action:** The closure passed to the `action` parameter defines what happens when the button is tapped.
- **Declarative Syntax:** SwiftUI’s declarative syntax relies heavily on closures to define the behavior of UI components, making code more concise and readable.

### **5.2 UIKit and Closures**

Closures are widely used in UIKit for animations and other event-driven programming tasks.

### UIKit Animation Example:
```swift
UIView.animate(withDuration: 0.3) {
    view.alpha = 0
}
```

In this UIKit example:
- **Animation Block:** A closure is passed to `UIView.animate`, which defines the changes to be animated. In this case, the `alpha` property of a `UIView` is animated to fade out over 0.3 seconds.

### **5.3 Delegates in Complex Event Handling**

Delegates remain a powerful tool for handling complex event-driven scenarios in iOS development, particularly when multiple methods are needed to manage related events.

### Example: UITableView Delegate
```swift
class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}
```

In this example:
- **UITableViewDelegate and UITableViewDataSource:** The view controller conforms to both the `UITableViewDelegate` and `UITableViewDataSource` protocols, implementing methods to manage row selection, data population, and cell configuration.
- **Delegate Method Calls:** These delegate methods are automatically called by the `UITableView`, allowing the developer to manage the behavior and appearance of the table view.

Delegates provide a structured and organized way to handle complex interactions within iOS applications, complementing closures for scenarios that require more granular control.

### References:
- [Apple Developer: SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [Apple Developer: UIKit](https://developer.apple.com/documentation/uikit)

## **6. Performance Considerations in iOS**

When using closures and delegates, it's crucial to be aware of potential retain cycles and memory management issues. Retain cycles occur when closures capture strong references to `self`, preventing objects from being deallocated, which can lead to memory leaks.

### Example of a Retain Cycle:
```swift
class MyViewController: UIViewController {
    var completionHandler: (() -> Void)?
    
    func setupCompletionHandler() {
        completionHandler = { [weak self] in
            self?.view.backgroundColor = .red
        }
    }
}
```

In this example:
- **Capture List:** The `[weak self]` capture list is used to create a weak reference to `self` inside the closure, preventing a strong reference cycle.
- **Memory Management:** By capturing `self` weakly, the closure does not prevent `self` from being deallocated, avoiding potential memory leaks.

Understanding and mitigating retain cycles is essential when working with closures and delegates, especially in long-lived objects like view controllers.

### References:
- [Apple Developer: Resolving Strong Reference Cycles for Closures](https://developer.apple.com/documentation/swift/avoiding_memory_leaks)

## **7. Advanced Closure Techniques in Swift**

Swift offers advanced features like `@escaping`, `@autoclosure`, and generic closures for more complex use cases. These features provide more control and flexibility when working with closures.

### Example of an `@escaping` Closure:
```swift
func performAsyncOperation(completion: @escaping () -> Void) {
    DispatchQueue.global().async {
        // Perform operation
        completion()
    }
}
```

In this example:
- **Escaping Closure:** The `@escaping` attribute is used to indicate that the closure will be executed after the function returns, which is common in asynchronous operations.
- **Asynchronous Operation:** The closure passed to `completion` is executed after the asynchronous operation completes.

This example highlights how `@escaping` allows closures to outlive the scope in which they were defined, a critical feature for asynchronous programming.

### References:
- [Swift Documentation: Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)

## **Bonus**
| Feature                | Async/Await                       | Combine                                | Closures                               | Delegate                               | RxSwift                               |
|------------------------|-----------------------------------|----------------------------------------|----------------------------------------|----------------------------------------|----------------------------------------|
| **Purpose**            | Handle asynchronous code with simpler syntax | Declarative framework for reactive programming | Pass code blocks as arguments           | Object-to-object communication         | Reactive programming for handling asynchronous code |
| **Paradigm**           | Synchronous-like, imperative      | Functional, declarative                | Functional                             | Delegation, object-oriented            | Functional, reactive                  |
| **Ease of Use**        | Easy to read and maintain         | Moderate complexity                    | Easy to moderate, depending on use case | Moderate                               | Can be complex for beginners          |
| **Concurrency**        | Built-in Swift concurrency model  | Supports concurrency through Publishers and Subscribers | No built-in concurrency support, relies on GCD/NSOperation | No inherent concurrency                | Uses Schedulers to manage concurrency |
| **Memory Management**  | Automatic                          | Automatic (Combine framework)          | Manual (capture lists to avoid retain cycles) | Needs manual care to prevent retain cycles | Requires usage of `DisposeBag` to manage memory   |
| **Typical Usage**      | Handling async tasks (e.g., API calls) | Data streams, chaining asynchronous tasks | Simple callbacks, completion handlers  | Communication between two related objects | Observing and reacting to UI or data changes |
| **Error Handling**     | `do-catch` with structured error handling | Built-in error propagation via `.catch()` | Manual error handling with optional/error types | Requires custom error handling         | Error handling using `.catchError()` and `.onError()` |
| **Syntax**             | `async` and `await` keywords      | Operators like `map`, `flatMap`, `sink` | `{ (parameters) -> ReturnType in code }` | Method implementation                  | Operators like `map`, `flatMap`, `subscribe` |
| **Readability**        | Very readable and intuitive       | Readable with practice, more verbose   | Can become cluttered in complex cases  | Readable for straightforward cases     | Less readable, especially with complex chains |
| **Learning Curve**     | Low to moderate                   | Moderate to high                       | Low to moderate                        | Low                                     | High                                  |
| **Framework Requirement** | Native Swift                     | Requires importing Combine             | Native Swift                           | Native Swift                           | Requires RxSwift library              |
| **Examples**           | Fetching data from API with `await` | Handling UI changes reactively         | Button tap handler with a closure      | UITableView delegate methods           | Reacting to text field input changes  |


Hope you find this article useful!! Thanks for reading. :) 
