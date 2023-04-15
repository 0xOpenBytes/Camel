# Camel

*Camel simplifies CoreML integration, so you don't have to hump it alone.*

Camel is a Swift library that simplifies the integration of CoreML models into your application. It provides a caching mechanism for compiled CoreML models and an easy-to-use interface for making predictions using those models.

## Usage

### Initializing Camel

You can create a new Camel instance by specifying a dictionary of CoreML models with associated keys:

```swift
let modelDictionary: [String: URL] = [
    "model1": Bundle.main.url(forResource: "Model1", withExtension: "mlmodel")!,
    "model2": Bundle.main.url(forResource: "Model2", withExtension: "mlmodel")!,
]

let camel = try Camel(models: modelDictionary)
```

Camel can use any Hashable type for the Key.

```swift
enum ModelKey: String {
    case model1, model2, model3, model4
}

let modelDictionary: [ModelKey: URL] = [
    .model1: Bundle.main.url(forResource: "Model1", withExtension: "mlmodel")!,
    .model2: Bundle.main.url(forResource: "Model2", withExtension: "mlmodel")!,
    .model3: URL(string: "https://example.com/Model3.mlmodel")!
]

let camel = try Camel(models: modelDictionary)

// Add a new model URL
try camel.add(modelURL: URL(string: "https://example.com/Model4.mlmodel")!, forKey: .model4)

// Predict using one of the models
let input = CamelInput(values: ["input1": 0.5, "input2": 0.8])
let output: CamelOutput = try camel.prediction(using: .model1, input: input)
```

### Making Predictions

Once you have initialized Camel, you can use it to make predictions on your CoreML models. To make a single prediction, you can use the prediction method:

```swift
let input = CamelInput(/* ... */)

do {
    let output: CamelOutput = try camel.prediction(using: "model1", input: input)
    // Use the output of the prediction
} catch {
    // Handle the error
}
```

To make multiple predictions at once, you can use the predictions method:

```swift
let inputs: [CamelInput] = [/* ... */]

do {
    let outputs: [CamelOutput] = try camel.predictions(using: "model1", inputs: inputs)
    // Use the outputs of the predictions
} catch {
    // Handle the error
}
```

### Caching Models

Camel automatically caches the compiled versions of your CoreML models to improve performance. If a compiled model already exists in the cache, Camel will use that model instead of compiling the original model again. You can manually add a model to the cache using the add method:

```swift
let modelURL = Bundle.main.url(forResource: "Model1", withExtension: "mlmodelc")!

do {
    try camel.add(modelURL: modelURL, forKey: "model1")
} catch {
    // Handle the error
}
```

## Additional Resources

### Apple [CoreML](https://developer.apple.com/documentation/coreml) Models

Apple provides a collection of pre-trained CoreML models that can be used for a variety of tasks. You can find these models at [developer.apple.com/machine-learning/models/](https://developer.apple.com/machine-learning/models/). These models cover a wide range of use cases, including image recognition, natural language processing, and more. 

***

- Limitations: Camel is designed to work specifically with CoreML models, so it may not be suitable for other machine learning frameworks. Additionally, it may not work with very large models that exceed the available memory on the device.

- Requirements: Camel requires a device running iOS 14 or later, macOS 11 or later, watchOS 7 or later, or tvOS 14 or later.

- License: Camel is released under the MIT license, which is a permissive open-source license that allows for free use, modification, and distribution of the software.

- Contributions: Contributions to Camel are welcome and encouraged! If you find a bug, or have an idea for a new feature, please open an issue on GitHub or submit a pull request with your changes. Be sure to follow the code of conduct and contribution guidelines outlined in the repository.
