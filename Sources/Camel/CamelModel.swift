import CoreML

/**
 A representation of a Core ML model that can make predictions using input data.
 */
public struct CamelModel {

    /// The Core ML model used to make predictions.
    public let model: MLModel

    /// The URL of the Core ML model file.
    public let modelURL: URL

    /// The URL of the compiled Core ML model file, used for faster predictions.
    public let fileURL: URL

    /**
     Initializes a new `CamelModel` instance with the given model URL.

     - Parameter modelURL: The URL of the Core ML model file to use.

     - Throws: An error if the Core ML model cannot be compiled or loaded.
     */
    public init(modelURL: URL) throws {
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]

        let compiledModelName = modelURL.lastPathComponent
        let permanentURL = appSupportURL.appendingPathComponent(compiledModelName)

        self.modelURL = modelURL
        self.fileURL = permanentURL

        if let compiledModel = try? MLModel(contentsOf: permanentURL) {
            model = compiledModel
        } else {
            let compiledModelURL = try MLModel.compileModel(at: modelURL)

            model = try MLModel(contentsOf: compiledModelURL)

            _ = try fileManager.replaceItemAt(
                permanentURL,
                withItemAt: compiledModelURL
            )
        }
    }

    /**
     Makes a prediction using the given input and returns the predicted output.

     - Parameters:
         - input: The input data used to make the prediction.
         - options: Additional options to use when making the prediction.

     - Returns: The predicted output data.

     - Throws: An error if the prediction fails.
     */
    public func prediction<Input: CamelInput, Output: CamelOutput>(
        input: Input,
        options: MLPredictionOptions = MLPredictionOptions()
    ) throws -> Output {
        Output(
            features: try model.prediction(
                from: input,
                options: options
            )
        )
    }

    /**
     Makes a prediction using the given input feature values and returns the predicted output.

     - Parameters:
         - input: A dictionary of input feature names and their corresponding feature values.
         - options: Additional options to use when making the prediction.

     - Returns: The predicted output data.

     - Throws: An error if the prediction fails.
     */
    public func prediction<Output: CamelOutput>(
        input: [String: MLFeatureValue],
        options: MLPredictionOptions = MLPredictionOptions()
    ) throws -> Output {
        Output(
            features: try model.prediction(
                from: CamelInput(values: input),
                options: options
            )
        )
    }

    /**
     Makes predictions using the given input data array and returns an array of predicted output data.

     - Parameters:
         - inputs: An array of input data used to make the predictions.
         - options: Additional options to use when making the predictions.

     - Returns: An array of predicted output data.

     - Throws: An error if any of the predictions fail.
     */
    public func predictions<Input: CamelInput, Output: CamelOutput>(
        inputs: [Input],
        options: MLPredictionOptions = MLPredictionOptions()
    ) throws -> [Output] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results: [Output] = []

        results.reserveCapacity(inputs.count)

        for i in 0 ..< batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  Output(features: outProvider)
            results.append(result)
        }

        return results
    }
}
