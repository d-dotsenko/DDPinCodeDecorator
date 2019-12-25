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

protocol DDPinCodeDecoratorViewInput {
    var output: DDPinCodeDecoratorViewOutput? { get set }
    var padding: UIEdgeInsets { get set }
    var shadow: DDPinCodeDecoratorShadowModel? { get set }
    var iconFont: UIFont? { get set }
    var symbolOffset: UIOffset? { get set }
    
    func provideIcons(icons: [DDPinCodeDecoratorIconProtocol])
    func showAllEmpty()
    func showAllSuccess()
    func showAllUnsuccess()
    func printSymbol(symbol: String, index: Int)
    func eraseSymbol(index: Int)
    func coverSymbol(index: Int)
}

protocol DDPinCodeDecoratorViewOutput: AnyObject {
    func didTapSymbol(_ symbol: String)
}

typealias DDPinCodeDecoratorIconProtocol = UIImageView & DDPinCodeDecoratorIconInput

class DDPinCodeDecoratorView: UITextField, DDPinCodeDecoratorViewInput {
    
    //MARK: - Public VARs
    
    weak var output: DDPinCodeDecoratorViewOutput?
    
    var padding: UIEdgeInsets = .zero {
        didSet {
            setupIcons()
        }
    }
    
    var shadow: DDPinCodeDecoratorShadowModel? {
        didSet {
            setupIcons()
        }
    }
    
    var iconFont: UIFont? {
        didSet {
            setupIcons()
        }
    }
    
    var symbolOffset: UIOffset? {
        didSet {
            setupIcons()
        }
    }
    
    //MARK: - Private VARs
    
    private var iconSize: CGSize = .zero
    private var fontFactor: CGFloat = 1
    
    private var icons: [DDPinCodeDecoratorIconProtocol]? {
        didSet {
            setupIcons()
        }
    }
    
    //MARK: - Life Cicle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupIcons()
    }
    
    //MARK: - Private
    
    private func setupIcons() {
        setupIconSize()
        clearIcons()
        setupIconsPositions()
        setupIconsShadow()
        addIcons()
        setupFontFactor()
    }
    
    private func setupIconSize() {
        let num = icons?.count ?? 0
        let imageWidth = bounds.width / CGFloat(num)
        let imageHeight = bounds.height
        iconSize = CGSize(width: imageWidth, height: imageHeight)
    }
    
    private func setupFontFactor() {
        guard let icon = icons?.first else { return }
        
        let emptyImage = icon.emptyImage
        if iconSize == .zero { return }
        
        let byHeight = emptyImage.size.height / icon.frame.size.height
        let byWidth = emptyImage.size.width / icon.frame.size.width
        
        fontFactor = max(byHeight, byWidth)
    }
    
    private func clearIcons() {
        self.subviews
            .lazy
            .filter { $0 is DDPinCodeDecoratorIconProtocol }
            .forEach { $0.removeFromSuperview() }
    }
    
    private func setupIconsPositions() {
        guard let icons = self.icons else { return }
        
        for (i, icon) in icons.enumerated() {
            icon.frame.size = iconSize
            icon.frame.origin = CGPoint(x: iconSize.width * CGFloat(i), y: 0)
            icon.bounds = icon.bounds.inset(by: padding)
            icon.contentMode = .scaleAspectFit
        }
    }
    
    private func addIcons() {
        guard let icons = self.icons else { return }
        
        icons.forEach { addSubview($0) }
    }
    
    private func setupIconsShadow() {
        guard let icons = self.icons else { return }
        
        icons.forEach { $0.shadow = shadow }
    }
    
    private func setupIconsFont() {
        guard let icons = self.icons else { return }
        
        icons.forEach { $0.shadow = shadow }
    }
    
    private func textToImage(drawText text: NSString, inImage image: UIImage) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        var aFont = iconFont ?? UIFont.systemFont(ofSize: 14)
        aFont = aFont.withSize(aFont.pointSize * fontFactor)
        var anSymbolOffset = symbolOffset ?? .zero
        anSymbolOffset = UIOffset(horizontal: anSymbolOffset.horizontal * fontFactor,
                                  vertical: anSymbolOffset.vertical * fontFactor)
        
        let attrs: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: aFont,
            NSAttributedString.Key.foregroundColor : UIColor.black,
        ]
        let textSize = text.size(withAttributes: attrs)
        var textPosition = CGPoint(x: (image.size.width - textSize.width)/2, y: (image.size.height - textSize.height)/2)
        textPosition = CGPoint(x: textPosition.x + anSymbolOffset.horizontal, y: textPosition.y + anSymbolOffset.vertical)
        let rect = CGRect(origin: textPosition, size: image.size)
        
        text.draw(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: attrs,
            context: nil
        )
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //MARK: - DDPinCodeDecoratorViewInput

    func provideIcons(icons: [DDPinCodeDecoratorIconProtocol]) {
        self.icons = icons
    }
    
    func showAllEmpty() {
        guard let icons = self.icons else { return }
        
        icons.forEach { $0.show(state: .empty) }
    }
    
    func showAllSuccess() {
        guard let icons = self.icons else { return }
        
        icons.forEach { $0.show(state: .success) }
    }
    
    func showAllUnsuccess() {
        guard let icons = self.icons else { return }
        
        icons.forEach { $0.show(state: .unsuccess) }
    }
    
    func printSymbol(symbol: String, index: Int) {
        guard let icon = icons?[index] else { return }
        let emptyImage = icon.emptyImage
        let symbol = symbol as NSString
        let symbolImage = textToImage(drawText: symbol, inImage: emptyImage)
        icon.keyImage = symbolImage
        icon.show(state: .key)
    }
    
    func eraseSymbol(index: Int) {
        guard let icon = icons?[index] else { return }
        icon.show(state: .empty)
    }
    
    func coverSymbol(index: Int) {
        guard let icon = icons?[index] else { return }
        icon.show(state: .secure)
    }
}

extension DDPinCodeDecoratorView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        output?.didTapSymbol(string)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isUserInteractionEnabled = false
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        isUserInteractionEnabled = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) ||
            action == #selector(cut(_:)) ||
            action == #selector(copy(_:)) ||
            action == #selector(select(_:)) ||
            action == #selector(selectAll(_:)) ||
            action == #selector(delete(_:)) ||
            action == #selector(makeTextWritingDirectionLeftToRight(_:)) ||
            action == #selector(makeTextWritingDirectionRightToLeft(_:)) ||
            action == #selector(toggleBoldface(_:)) ||
            action == #selector(toggleItalics(_:)) ||
            action == #selector(toggleUnderline(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
}
