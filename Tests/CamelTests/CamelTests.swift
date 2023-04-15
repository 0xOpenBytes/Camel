import CoreML
import XCTest
@testable import Camel

final class CamelTests: XCTestCase {
    func testExample() async throws {
        enum CamelKey {
            case mobileNetV2
        }

        let modelURLString = "https://ml-assets.apple.com/coreml/models/Image/ImageClassification/MobileNetV2/MobileNetV2.mlmodel"
        let modelURL = try XCTUnwrap(URL(string: modelURLString))
        let saveURL = FileManager.default.urls(
            for: .downloadsDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent("MobileNetV2.mlmodel")

        let (data, _) = try await URLSession.shared.data(from: modelURL)

        try data.write(to: saveURL)

        let camel = try Camel<CamelKey>(
            models: [
                .mobileNetV2: URL(
                    fileURLWithPath: saveURL.path
                )
            ]
        )

        let imageURLString = "https://developer.apple.com/machine-learning/models/images/ImageClassification3.png"
        let imageURL = try XCTUnwrap(URL(string: imageURLString))

        let output = try camel.prediction(
            using: .mobileNetV2,
            input: [
                "image": MLFeatureValue(
                    imageAt: imageURL,
                    pixelsWide: 224,
                    pixelsHigh: 224,
                    pixelFormatType: kCVPixelFormatType_32ARGB
                )
            ]
        )

        let prediction = try XCTUnwrap(output.featureValue(for: "classLabel"))

        XCTAssert(prediction.stringValue.contains("elephant"))

        try FileManager.default.removeItem(at: saveURL)

        let model = try camel.resolve(.mobileNetV2)

        try FileManager.default.removeItem(at: model.fileURL)
    }
}
