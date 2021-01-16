
import Foundation

struct ColorFilter {
    struct Blur {
        static let effect = "blur"
        static let filter = "CIGaussianBlur"
    }
    
    struct Noir {
        static let effect = "noir"
        static let filter = "CIPhotoEffectNoir"
    }
    
    struct Invert {
        static let effect = "invert"
        static let filter = "CIColorInvert"
    }
    
    struct Sepia {
        static let effect = "sepia"
        static let filter = "CISepiaTone"
    }
    
    struct Fade {
        static let effect = "fade"
        static let filter = "CIPhotoEffectFade"
    }
    
    struct Chrome {
        static let effect = "chrome"
        static let filter = "CIPhotoEffectChrome"
    }
  
}
