/*
 The MIT License (MIT)
 
 Copyright (c) 2019 Dmitriy Dotsenko
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

public struct DDPinCodeDecoratorShadowModel {
    
    var color: UIColor = UIColor.black
    var opacity: Float = 0.5
    var offSet: CGSize = CGSize(width: 1.0, height: 1.0)
    var radius: CGFloat = 5
    var scale: Bool = true
    
    public init(color: UIColor? = nil,
         opacity: Float? = nil,
         offSet: CGSize? = nil,
         radius: CGFloat? = nil,
         scale: Bool? = nil) {
        
        if let aColor = color { self.color = aColor }
        if let anOpacity = opacity { self.opacity = anOpacity }
        if let anOffSet = offSet { self.offSet = anOffSet }
        if let aRadius = radius { self.radius = aRadius }
        if let aScale = scale { self.scale = aScale }
    }
}
