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

public protocol DDPinCodeDecoratorProtocol: AnyObject {
    /*
     The view that the decorator manages.
     */
    var view: UITextField? { get }
    
    /*
     The string that contains entered characters
     Default is ""
     */
    var resultString: String { get }
    
    /*
     The receiver’s delegate.
     */
    var delegate: DDPinCodeDecoratorOutput? { get set}
    
    /*
     The font used to display the text.
     Default is UIFont.systemFont(ofSize: 14)
     */
    var font: UIFont? { get set }
    
    /*
     The shadow used to display the icons.
     Default is:
     color = UIColor.black
     opacity = 0.5
     offSet = CGSize(width: 1.0, height: 1.0)
     radius = 5
     scale = true
     */
    var shadow: DDPinCodeDecoratorShadowModel? { get set }
    
    /*
     The delay from the symbol is displayed until the secure image is displayed
     Default is 0.2
     */
    var secureDelay: Double? { get set }
    
    /*
     A Boolean value that determines whether the keyboard is accessible
     Default is true
     */
    var isEnableKeyboard: Bool? { get set }
    
    /*
     The array with secure images.
     The number of pictures is equal to the number of symbols (icons).
     */
    var secureImagesArray: [UIImage] { get set }
    
    /*
     The image for initial display of all icons
     */
    var emptyImage: UIImage { get set }
    
    /*
     The image of all icons to display successful input
     */
    var successImage: UIImage { get set }
    
    /*
     The image of all icons to display unsuccessful input
     */
    var unsuccessImage: UIImage { get set }
    
    func addSymbol(_ symbol: String)
    func delSymbol()
    
    func showSuccess()
    func showUnsuccess()
    
    /*
     Do not allow user to enter symbols
     */
    func stopTapping()
    func allowTapping()
    
    func showKeyboard()
    func hideKeyboard()
    
    /*
     Display all icons as initial and remove all symbols
     */
    func clear()
    
    /*
     Optional
     Insets for all icons
     Default is .zero
     */
    var padding: UIEdgeInsets { get set }
    var symbolOffset: UIOffset? { get set }
}

public protocol DDPinCodeDecoratorOutput: AnyObject {
    /*
     Optional
     Called when all symbols are set
     */
    func provideResult(module: DDPinCodeDecoratorProtocol, result: String)
}

extension DDPinCodeDecoratorProtocol {
    var padding: UIEdgeInsets {
        get {
            return .zero
        }
        set {}
    }
    
    var symbolOffset: UIOffset? {
        get {
            return .zero
        }
        set {}
    }
}

extension DDPinCodeDecoratorOutput {
    public func provideResult(module: DDPinCodeDecoratorProtocol, result: String) {}
}

typealias DDDecoratorView = UITextField & DDPinCodeDecoratorViewInput

public class DDPinCodeDecorator: DDPinCodeDecoratorProtocol, DDPinCodeDecoratorViewOutput {

    //MARK: - Public VARs
    
    open var view: UITextField? {
        set {
            self._view = newValue as? DDDecoratorView
        }
        get {
            return self._view
        }
    }
    open var delegate: DDPinCodeDecoratorOutput?
    open var resultString: String = "" {
        didSet {
            print(self.resultString)
        }
    }
    
    open var padding: UIEdgeInsets = .zero {
        didSet {
            setup()
        }
    }
    
    open var symbolOffset: UIOffset? {
        didSet {
            setup()
        }
    }
    
    open var shadow: DDPinCodeDecoratorShadowModel? {
        didSet {
            setup()
        }
    }
    
    open var font: UIFont? {
        didSet {
            setup()
        }
    }
    
    open var secureDelay: Double? {
        didSet {
            setup()
        }
    }
    
    open var isEnableKeyboard: Bool? {
        didSet {
            setup()
        }
    }
    
    open var secureImagesArray: [UIImage] {
        set {
            model.arraySecureImages = newValue
        }
        get { return [] }
    }
    
    open var emptyImage: UIImage {
        set {
            model.emptyImage = newValue
        }
        get { return UIImage() }
    }
    
    open var successImage: UIImage {
        set {
            model.successImage = newValue
        }
        get { return UIImage() }
    }
    
    open var unsuccessImage: UIImage {
        set {
            model.unsuccessImage = newValue
        }
        get { return UIImage() }
    }
    
    //MARK: - Private VARs
    
    private var _view: DDDecoratorView?
    
    private var model = DDPinCodeDecoratorModel() {
        didSet {
            setup()
        }
    }
    private var isStop: Bool = false
    private var index: Int {
        set {
            if newValue > model.arraySecureImages?.count ?? 0 { return } // 1 more than count
            if newValue < -1 { return } // 1 less than 0
            _index = newValue
        }
        get {
            return _index
        }
    }
    
    private var _index: Int = -1
    
    //MARK: - Life Cicle
    
    public init(frame: CGRect) {
        view = DDPinCodeDecoratorView(frame: frame)
    }
    
    //MARK: - Private
    
    private func setup() {
        guard let arraySecureImages = model.arraySecureImages else { return }
        guard let emptyImage = model.emptyImage else { return }
        
        let successImage = model.successImage
        let unsuccessImage = model.unsuccessImage
        
        let icons = createIcons(arraySecureImages: arraySecureImages,
                                emptyImage: emptyImage,
                                successImage: successImage,
                                unsuccessImage: unsuccessImage)
        _view?.provideIcons(icons: icons)
        _view?.padding = padding
        _view?.shadow = shadow
        _view?.iconFont = font
        _view?.symbolOffset = symbolOffset
        _view?.isUserInteractionEnabled = isEnableKeyboard ?? true
        _view?.output = self
        _view?.showAllEmpty()
    }
    
    private func createIcons(arraySecureImages: [UIImage],
                             emptyImage: UIImage,
                             successImage: UIImage?,
                             unsuccessImage: UIImage?) -> [DDPinCodeDecoratorIcon] {
        var icons = [DDPinCodeDecoratorIcon]()
        
        for (_, secureImage) in arraySecureImages.enumerated() {
            let icon = DDPinCodeDecoratorIcon(frame: .zero,
                                           emptyImage: emptyImage,
                                           secureImage: secureImage,
                                           successImage: successImage,
                                           unsuccessImage: unsuccessImage)
            icons.append(icon)
            
        }
        return icons
    }
    
    private func checkResult() {
        if resultString.count == model.arraySecureImages?.count {
            delegate?.provideResult(module: self, result: resultString)
        }
    }
    
    //MARK: - DDPinCodeDecoratorViewOutput
    
    func didTapSymbol(_ symbol: String) {
        if let char = symbol.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92) {
                delSymbol()
            } else {
                addSymbol(symbol)
            }
        }
    }
    
    //MARK: - DDPinCodeDecoratorProtocol
    
    open func addSymbol(_ symbol: String) {
        if isStop { return }
        
        index += 1
        if index >= model.arraySecureImages?.count ?? 0 { return }
        
        var aSymbol = symbol
        if let lastChar = symbol.last { aSymbol = String(lastChar) }
        
        _view?.printSymbol(symbol: aSymbol, index: index)
        resultString += aSymbol
        let delay = secureDelay ?? 0.2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak weakSelf = self, index] in
            guard let strongSelf = weakSelf else { return }
            strongSelf._view?.coverSymbol(index: index)
            strongSelf.checkResult()
        }
    }
    
    open func delSymbol() {
        if isStop { return }
        if index < 0 { return }
        
        guard let count = model.arraySecureImages?.count else { return }
        
        if index >= count {
            index = count - 1
        }
        resultString.removeLast()
        _view?.eraseSymbol(index: index)
        index -= 1
    }
    
    open func clear() {
        index = -1
        resultString = ""
        _view?.showAllEmpty()
    }
    
    open func showSuccess() {
        _view?.showAllSuccess()
    }
    
    open func showUnsuccess() {
        _view?.showAllUnsuccess()
    }
    
    open func stopTapping() {
        isStop = true
    }
    
    open func allowTapping() {
        isStop = false
    }
    
    open func showKeyboard() {
        view?.becomeFirstResponder()
    }
    
    open func hideKeyboard() {
        view?.resignFirstResponder()
    }
}
