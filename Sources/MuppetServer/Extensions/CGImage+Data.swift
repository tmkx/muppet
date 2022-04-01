import Foundation
import CoreImage

extension CGImage {
    public func pngData() -> Data? {
        let cfData: CFMutableData = CFDataCreateMutable(nil, 0)
        if let dst = CGImageDestinationCreateWithData(cfData, kUTTypePNG as CFString, 1, nil) {
            CGImageDestinationAddImage(dst, self, nil)
            if CGImageDestinationFinalize(dst) {
                return cfData as Data
            }
        }
        return nil
    }
}
