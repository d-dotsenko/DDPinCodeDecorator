//
//  ViewController.swift
//  PinCodeDecoratorExample
//
//  Created by Dotsenko  on 19.12.2019.
//  Copyright © 2019 Dotsenko . All rights reserved.
//

import UIKit
import PinCodeDecorator

class ViewController: UIViewController {

    var pinCodeApple: DDPinCodeDecoratorProtocol?
    var pinCodeSquare: DDPinCodeDecoratorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "swamp4")!)
        view.addLightBlur()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    @IBAction func pinTouched() {
        let pinVC = PinViewController()
        navigationController?.pushViewController(pinVC, animated: true)
    }
    
    @IBAction func passwordTouched() {
        let passwordVC = PasswordViewController()
        navigationController?.pushViewController(passwordVC, animated: true)
    }
    

    func getAppleModuleFrame() -> CGRect {
        let x: CGFloat = 40
        let y: CGFloat = 100
        let width = view.frame.size.width - (2*x)
        let height = view.frame.size.height/12
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func getSquareModuleFrame() -> CGRect {
        let x: CGFloat = 40
        let y: CGFloat = 300
        let width = view.frame.size.width - (2*x)
        let height = view.frame.size.height/10
        
        return CGRect(x: x, y: y, width: width, height: height)
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
    
    func animate2(module: DDPinCodeDecoratorProtocol) {
        guard let aView = module.view else { return }
        
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-0.2, 0.2, -0.2, 0.2, -0.1, 0.1, -0.05, 0.05, 0.0]
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        
        aView.layer.add(animation, forKey: addressOf(module))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pinCodeApple?.view?.frame = getAppleModuleFrame()
        pinCodeSquare?.view?.frame = getSquareModuleFrame()
    }
}

extension ViewController: DDPinCodeDecoratorOutput {
    
    func provideResult(module: DDPinCodeDecoratorProtocol, result: String) {
        if module === self.pinCodeApple {
            if result == "logo" {
                module.showSuccess()
            } else {
                module.showUnsuccess()
                animate(module: module)
            }
        } else {
            if result == "company" {
                module.showSuccess()
            } else {
                module.showUnsuccess()
                animate2(module: module)
            }
        }
    }
}

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        var module: DDPinCodeDecoratorProtocol?
        
        if let animation = pinCodeApple?.view?.layer.animation(forKey: addressOf(pinCodeApple!)) {
            let animBasic = anim as CAAnimation
            let animationBasic = animation as CAAnimation
            if animBasic === animationBasic {
                module = pinCodeApple
            }
        }
        if let animation = pinCodeSquare?.view?.layer.animation(forKey: addressOf(pinCodeSquare!)) {
            let animBasic = anim as CAAnimation
            let animationBasic = animation as CAAnimation
            if animBasic === animationBasic {
                module = pinCodeSquare
            }
        }
        module?.clear()
    }
    
    func addressOf(_ obj: AnyObject) -> String {
        let addr = unsafeBitCast(obj, to: Int.self)
        return String(format: "%p", addr)
    }
}

extension UIView {
    func addLightBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        sendSubviewToBack(blurEffectView)
    }
}

extension CALayer {
    
    @IBInspectable var borderUIColor: UIColor {
        set {
            borderColor = newValue.cgColor
        }
        get {
            return UIColor()
        }
    }
    
}
