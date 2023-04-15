import CoreML

/**
`CamelInput` provides a representation of the input features to a Core ML model.

You can use this class to provide input to a Core ML model for prediction. It conforms to `MLFeatureProvider`, which allows it to be passed to the prediction methods of a Core ML model.

To create a `CamelInput` object, you can provide a dictionary of feature names and their corresponding MLFeatureValue instances.

Example usage:
  ```swift
 let input = CamelInput(
    values: [
        "input": MLFeatureValue(imageAt: imageURL, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB),
        "mean": MLFeatureValue(double: 127.5),
        "std": MLFeatureValue(double: 127.5)
    ]
 )

 let output = try model.prediction(from: input)
 ```

 Note: All feature names provided in the input dictionary must match the names of the input features in the Core ML model.

 SeeAlso: `CamelOutput`, `MLFeatureProvider`
 */
open class CamelInput: MLFeatureProvider {
    private let values: [String: MLFeatureValue]

    /// A set of all the feature names for this input.
    open var featureNames: Set<String> { Set(values.keys) }

    /**
     Initializes a new `CamelInput` object with the given feature values.

     - Parameter values: A dictionary of feature names and feature values.
     */
    public init(values: [String: MLFeatureValue]) {
        self.values = values
    }

    /**
     Returns the feature value for the given feature name.

     - Parameter featureName: The name of the feature.
     
     - Returns: The feature value for the given feature name, or nil if the feature name is not found.
     */
    open func featureValue(for featureName: String) -> MLFeatureValue? {
        values[featureName]
    }
}
