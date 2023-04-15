import CoreML

/**
 A class that wraps an `MLFeatureProvider` and provides an interface to access its features.

 You can access the features through the `featureValue(for:)` method.

 `CamelOutput` can be used to wrap the output of an `MLModel` prediction.
 */
open class CamelOutput: MLFeatureProvider {

    /// The underlying MLFeatureProvider that this output wraps.
    public let provider: MLFeatureProvider

    /// The set of feature names provided by the output.
    open var featureNames: Set<String> { provider.featureNames }

    /**
     Creates an instance of `CamelOutput` that wraps the provided `MLFeatureProvider`.

     - Parameter features: The `MLFeatureProvider` instance to wrap.
    */
    public required init(features provider: MLFeatureProvider) {
        self.provider = provider
    }
    /**
     Retrieves the `MLFeatureValue` associated with the given feature name.

     - Parameter featureName: The name of the feature to retrieve.

     - Returns: The `MLFeatureValue` associated with the given feature name, or `nil` if no such feature exists.
    */
    open func featureValue(for featureName: String) -> MLFeatureValue? {
        provider.featureValue(for: featureName)
    }
}
