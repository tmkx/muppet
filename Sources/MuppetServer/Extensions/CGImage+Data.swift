import Foundation
import CoreImage

extension CGImage {
    public func imageData(type: CFString) -> Data? {
        let cfData: CFMutableData = CFDataCreateMutable(nil, 0)
        if let dst = CGImageDestinationCreateWithData(cfData, type, 1, nil) {
            CGImageDestinationAddImage(dst, self, nil)
            if CGImageDestinationFinalize(dst) {
                return cfData as Data
            }
        }
        return nil
    }

    public func pngData() -> Data? {
        imageData(type: kUTTypePNG)
    }

    public func jpegData() -> Data? {
        imageData(type: kUTTypeJPEG)
    }
}
