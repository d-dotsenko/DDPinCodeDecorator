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

protocol DDPinCodeDecoratorIconInput: AnyObject {
    var emptyImage: UIImage { get set }
    var keyImage: UIImage? { get set }
    var shadow: DDPinCodeDecoratorShadowModel? { get set }
    func show(state: DDPinCodeDecoratorIconState)
}

protocol DDPinCodeDecoratorIconOutput {
    
}

enum DDPinCodeDecoratorIconState {
    case empty
    case key
    case secure
    case success
    case unsuccess
}

class DDPinCodeDecoratorIcon: UIImageView, DDPinCodeDecoratorIconInput {
    
    //MARK: - Public VARs
    
    var emptyImage: UIImage
    
    var keyImage: UIImage? {
        didSet {
            setup()
        }
    }
    
    var shadow: DDPinCodeDecoratorShadowModel? {
        didSet {
            setup()
        }
    }
    
    //MARK: - Private VARs
    
    private var secureImage: UIImage
    private var successImage: UIImage?
    private var unsuccessImage: UIImage?
    
    private var state: DDPinCodeDecoratorIconState = .empty {
        didSet {
            setup()
        }
    }
    
    //MARK: - Life Cicle
    
    init(frame: CGRect,
         emptyImage: UIImage,
         secureImage: UIImage,
         successImage: UIImage? = nil,
         unsuccessImage: UIImage? = nil) {
        
        self.emptyImage = emptyImage
        self.secureImage = secureImage
        self.successImage = successImage
        self.unsuccessImage = unsuccessImage
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    //MARK: - Private
    
    private func setup() {
        switch state {
        case .empty:
            image = emptyImage
        case .key:
            image = keyImage
        case .secure:
            image = secureImage
        case .success:
            guard let successImage = self.successImage else { return }
            image = successImage
        case .unsuccess:
            guard let unsuccessImage = self.unsuccessImage else { return }
            image = unsuccessImage
        }
        
        drawShadow()
    }
    
    private func drawShadow() {
        guard let shadow = self.shadow else { return }
        
        layer.masksToBounds = false
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOpacity = shadow.opacity
        layer.shadowOffset = shadow.offSet
        layer.shadowRadius = shadow.radius
        layer.shouldRasterize = true
        layer.rasterizationScale = shadow.scale ? UIScreen.main.scale : 1
    }
    
    //MARK: - PinCodeDecorateIconInput
    
    func show(state: DDPinCodeDecoratorIconState) {
        self.state = state
    }
    
}
