//
//  PinViewController.swift
//  PinCodeDecoratorExample
//
//  Created by Dotsenko  on 19.12.2019.
//  Copyright © 2019 Dotsenko . All rights reserved.
//

import UIKit
import PinCodeDecorator

class PinViewController: UIViewController {
    
    @IBOutlet weak var pinCodeContenView: UIView!
    
    let pinCodeDecorator = DDPinCodeDecorator(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPinCodeDecorator()
        getButtons()
        
        title = "Pin is \"1234\""
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        pinCodeDecorator.view?.frame = pinCodeContenView.bounds
    }
    
    func getButtons() {
        for i in 1...10 {
            if let button = view.viewWithTag(i) as? UIButton {
                button.layer.cornerRadius = button.frame.width / 2
                button.tintColor = UIColor.black
                button.layer.borderWidth = 2.0
                button.layer.borderColor = UIColor(hex: 0xf2f2f2).cgColor
            }
        }
    }
    
    func setupPinCodeDecorator() {
        let emptyAppleImage = UIImage(named: "emptyApple") ?? UIImage()
        let successAppleImage = UIImage(named: "successSmile") ?? UIImage()
        let unsuccessAppleImage = UIImage(named: "unsuccessSmile") ?? UIImage()
        
        var appleImages = [UIImage]()
        appleImages.append(UIImage(named: "L_logo") ?? UIImage())
        appleImages.append(UIImage(named: "O_logo") ?? UIImage())
        appleImages.append(UIImage(named: "G_logo") ?? UIImage())
        appleImages.append(UIImage(named: "O_logo") ?? UIImage())
        
        pinCodeDecorator.delegate = self
        pinCodeDecorator.secureImagesArray = appleImages
        pinCodeDecorator.emptyImage = emptyAppleImage
        pinCodeDecorator.successImage = successAppleImage
        pinCodeDecorator.unsuccessImage = unsuccessAppleImage
        pinCodeDecorator.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        pinCodeDecorator.shadow = DDPinCodeDecoratorShadowModel(color: UIColor.black,
                                                                opacity: 0.5,
                                                                offSet: CGSize(width: 1, height: 1),
                                                                radius: 5,
                                                                scale: true)
        pinCodeDecorator.font = UIFont.systemFont(ofSize: 24)
        pinCodeDecorator.symbolOffset = UIOffset(horizontal: 0, vertical: 3)
        pinCodeDecorator.secureDelay = 0.2
        pinCodeDecorator.isEnableKeyboard = false
        
        guard let appleView = pinCodeDecorator.view else { return }
        pinCodeContenView.addSubview(appleView)
    }
    
    func animate(module: DDPinCodeDecoratorProtocol) {
        guard let aView = module.view else { return }
        
        let fromPoint = CGPoint(x: aView.center.x - 10, y: aView.center.y)
        let toPoint = CGPoint(x: aView.center.x + 10, y: aView.center.y)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: fromPoint)
        animation.toValue = NSValue(cgPoint: toPoint)
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        
        aView.layer.add(animation, forKey: addressOf(module))
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let symbol = String(sender.tag)
        pinCodeDecorator.addSymbol(symbol)
    }
    
    @IBAction func delButton(_ sender: UIButton) {
        pinCodeDecorator.delSymbol()
    }
}

extension PinViewController: DDPinCodeDecoratorOutput {
    
    func provideResult(module: DDPinCodeDecoratorProtocol, result: String) {
        if module === self.pinCodeDecorator {
            if result == "1234" {
                module.showSuccess()
            } else {
                module.showUnsuccess()
                animate(module: module)
            }
        }
    }
}

extension PinViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        var module: DDPinCodeDecoratorProtocol?
        
        if let animation = pinCodeDecorator.view?.layer.animation(forKey: addressOf(pinCodeDecorator)) {
            let animBasic = anim as CAAnimation
            let animationBasic = animation as CAAnimation
            if animBasic === animationBasic {
                module = pinCodeDecorator
            }
        }
        module?.clear()
    }
    
    func addressOf(_ obj: AnyObject) -> String {
        let addr = unsafeBitCast(obj, to: Int.self)
        return String(format: "%p", addr)
    }
}


extension UIColor {
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }
}
