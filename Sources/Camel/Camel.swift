import Cache
import CoreML

/// A generic caching mechanism for `CamelModel`s associated with keys of type `Key`.
public class Camel<Key: Hashable>: Cache<Key, CamelModel> {

    /// Initializes a new instance of `Camel` with an empty cache.
    internal required init(initialValues: [Key: Value] = [:]) {
        super.init(initialValues: initialValues)
    }

    /**
     Initializes a new instance of `Camel` with the given `models` and adds them to the cache.

     - Parameter models: A dictionary mapping keys of type `Key` to URLs of `MLModel` files.

     - Throws: An error if any of the `MLModel` files cannot be loaded or compiled.
     */
    public init(models: [Key: URL]) throws {
        super.init()

        for (_, keyValue) in models.enumerated() {
            try add(modelURL: keyValue.value, forKey: keyValue.key)
        }
    }

    /**
     Adds a new `CamelModel` to the cache for the specified key.

     - Parameters:
         - modelURL: The URL of the `MLModel` file to load and compile.
         - key: The key to associate with the `CamelModel` in the cache.

     - Throws: An error if the `MLModel` file cannot be loaded or compiled.
     */
    public func add(modelURL: URL, forKey key: Key) throws {
        set(value: try CamelModel(modelURL: modelURL), forKey: key)
    }

    /**
     Returns the prediction output for a given `input` using the `CamelModel` associated with the specified `key`.

     - Parameters:
        - using: The key associated with the `CamelModel` in the cache.
        - input: The input to make a prediction for.
        - options: Additional options for the prediction.

     - Throws: An error if the `CamelModel` for the specified `key` cannot be found or if the prediction fails.

     - Returns: The prediction output as a `CamelOutput` object.
     */
    public func prediction<Input: CamelInput, Output: CamelOutput>(
        using key: Key,
        input: Input,
        options: MLPredictionOptions = MLPredictionOptions()
    ) throws -> Output {
        try resolve(key).prediction(
            input: input,
            options: options
        )
    }

    /**
     Returns the prediction output for a given `input` dictionary using the `CamelModel` associated with the specified `key`.

     - Parameters:
        - using: The key associated with the `CamelModel` in the cache.
        - input: A dictionary of `MLFeatureValue` objects representing the input to make a prediction for.
        - options: Additional options for the prediction.

     - Throws: An error if the `CamelModel` for the specified `key` cannot be found or if the prediction fails.

     - Returns: The prediction output as a `CamelOutput` object.
     */
    public func prediction<Output: CamelOutput>(
        using key: Key,
        input: [String: MLFeatureValue],
        options: MLPredictionOptions = MLPredictionOptions()
    ) throws -> Output {
        try resolve(key).prediction(
            input: input,
            options: options
        )
    }

    /**
     Returns an array of predicted outputs for the given array of inputs, using the model associated with the specified key.

     - Parameters:
         - using: The key used to identify the model to be used for prediction.
         - inputs: An array of inputs to predict the outputs for.
         - options: Optional `MLPredictionOptions` object to configure prediction.

     - Throws: An error of type `CacheError` if the model associated with the specified key is not found in the cache, or an error of type `Error` thrown by the predictions method of the `CamelModel` class.

     - Returns: An array of predicted outputs for the given array of inputs, using the model associated with the specified key.
     */
    public func predictions<Input: CamelInput, Output: CamelOutput>(
        using key: Key,
        inputs: [Input],
        options: MLPredictionOptions = MLPredictionOptions()
    ) throws -> [Output] {
        try resolve(key).predictions(
            inputs: inputs,
            options: options
        )
    }
}
