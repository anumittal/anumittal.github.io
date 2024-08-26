While covering examples and use case of [Closure in Swift](https://anumittal.in/Closure-in-swift) article I thought of adding a short article on uses of blocks in Objective-C. Closures are referred to as "blocks" in ObjC. Blocks are a powerful feature that allows developers to encapsulate code and pass it around, similar to functions or methods but with the ability to capture state from the surrounding context. Some common use cases for using blocks in Objective-C are:

### 1. **Completion Handlers**

One of the most common use cases for blocks in Objective-C is as completion handlers for asynchronous tasks. This allows code to be executed once an operation, such as a network request or a file operation, is completed.

**Example:**
```objc
- (void)downloadFileWithCompletion:(void (^)(NSData *data, NSError *error))completion {
    // Simulate a network download
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = ... // downloaded data
        NSError *error = ... // download error

        // Call the completion block on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(data, error);
            }
        });
    });
}
```
In this example:
- The `downloadFileWithCompletion:` method accepts a block as a parameter.
- The block is called when the download is complete, passing the data and any error that occurred.

### 2. **Event Handling**

Blocks can be used to handle events, such as button presses or other user interactions. This is particularly useful in situations where the handling code is small and specific to a single use case.

**Example:**
```objc
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

- (void)buttonPressed:(UIButton *)button {
    void (^handler)(void) = ^{
        NSLog(@"Button was pressed");
    };
    handler();
}
```

In this example:
- A block is defined within the `buttonPressed:` method to handle the button press.
- This block could be passed around or stored for later execution.

### 3. **Iteration Over Collections**

Blocks can be used to iterate over collections like arrays and dictionaries. This is similar to how closures are used in Swift's `forEach` method.

**Example:**
```objc
NSArray *array = @[@"Apple", @"Banana", @"Cherry"];
[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSLog(@"Object at index %lu is %@", (unsigned long)idx, obj);
}];
```

In this example:
- The `enumerateObjectsUsingBlock:` method iterates over each element in the array.
- The block is executed for each element, receiving the object, its index, and a pointer to a `BOOL` that can stop the iteration early if needed.

### 4. **Custom Sorting**

Blocks are often used to define custom sorting criteria for collections.

**Example:**
```objc
NSArray *unsortedArray = @[@3, @1, @2, @5, @4];
NSArray *sortedArray = [unsortedArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [obj1 compare:obj2];
}];
```

In this example:
- The `sortedArrayUsingComparator:` method sorts the array based on the logic provided in the block.
- The block compares two objects and returns the appropriate `NSComparisonResult` (`NSOrderedAscending`, `NSOrderedSame`, or `NSOrderedDescending`).

### 5. **Animations**

Blocks are used in Objective-C to define animations, making it easy to encapsulate the animation logic.

**Example:**
```objc
[UIView animateWithDuration:0.5 animations:^{
    self.view.alpha = 0.0;
} completion:^(BOOL finished) {
    NSLog(@"Animation completed");
}];
```

In this example:
- The `animateWithDuration:animations:completion:` method takes two blocks: one for the animation itself and another for the completion handler, which is called when the animation finishes.

### 6. **Deferred Execution**

Blocks can be used to defer execution of a piece of code until a specific condition is met, or to pass logic around that should only be executed under certain circumstances.

**Example:**
```objc
void (^deferredBlock)(void) = ^{
    NSLog(@"This block is executed later");
};

// Execute the block later in the code
deferredBlock();
```

This allows code to be encapsulated and executed at a later time, possibly in response to an event or condition.

### 7. **Dispatching Tasks with GCD**

Blocks are heavily used with Grand Central Dispatch (GCD) to execute tasks concurrently or on specific queues.

**Example:**
```objc
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // Background task
    NSData *data = ... // perform time-consuming task

    dispatch_async(dispatch_get_main_queue(), ^{
        // Update UI on the main thread
        self.imageView.image = [UIImage imageWithData:data];
    });
});
```

In this example:
- A block is used to perform a time-consuming task on a background thread.
- Another block is used to update the UI on the main thread once the task is complete.

### 8. **Memory Management and Block Properties**

Blocks can capture variables from their surrounding scope. In Objective-C, when blocks capture object pointers, they also retain them. This can lead to retain cycles if not handled properly, especially when blocks capture `self`. It’s common to use weak references to avoid such retain cycles.

**Example:**
```objc
__weak typeof(self) weakSelf = self;
[self fetchDataWithCompletion:^(NSData *data, NSError *error) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf updateUIWithData:data];
}];
```

In this example:
- `__weak` is used to create a weak reference to `self` to avoid a retain cycle.
- `__strong` is used within the block to create a strong reference, ensuring `self` is still alive while the block is executing.

### 9. **Functional Programming Constructs**

Blocks can be used to implement functional programming concepts, such as map, filter, and reduce operations on collections.

**Example:**
```objc
NSArray *numbers = @[@1, @2, @3, @4, @5];
NSArray *squaredNumbers = [numbers valueForKeyPath:@"@unionOfObjects.self.@self.@self"];
```

In this example:
- `valueForKeyPath:` is used with a block to transform each element in the array, demonstrating a functional approach to collection processing.
