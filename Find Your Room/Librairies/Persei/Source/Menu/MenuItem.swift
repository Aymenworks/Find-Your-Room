// For License please refer to LICENSE file in the root of Persei project

import Foundation
import UIKit.UIImage

public struct MenuItem {
    public var image: UIImage
    public var highlightedImage: UIImage?
    
    public var backgroundColor = UIColor.whiteColor()
    public var highlightedBackgroundColor =  UIColor.whiteColor()
    public var shadowColor = UIColor(white: 0.1, alpha: 0.3)
    
    // MARK: - Init
    public init(image: UIImage, highlightedImage: UIImage? = nil) {
        self.image = image
        self.highlightedImage = highlightedImage
    }    
}
