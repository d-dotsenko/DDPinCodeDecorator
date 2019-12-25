//
//  PasswordViewController.swift
//  PinCodeDecoratorExample
//
//  Created by Dotsenko  on 20.12.2019.
//  Copyright © 2019 Dotsenko . All rights reserved.
//

import UIKit
import PinCodeDecorator

class PasswordViewController: UIViewController {
    
    @IBOutlet weak var pinCodeContenView: UIView!
    
    let passwordDecorator = DDPinCodeDecorator(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emptySquareImage = UIImage(named: "emptySquare") ?? UIImage()
        let successSquareImage = UIImage(named: "thumbUp") ?? UIImage()
        let unsuccessSquareImage = UIImage(named: "thumbDown") ?? UIImage()
        
        var squareImages = [UIImage]()
        squareImages.append(UIImage(named: "C_company") ?? UIImage())
        squareImages.append(UIImage(named: "O_company") ?? UIImage())
        squareImages.append(UIImage(named: "M_company") ?? UIImage())
        squareImages.append(UIImage(named: "P_company") ?? UIImage())
        squareImages.append(UIImage(named: "A_company") ?? UIImage())
        squareImages.append(UIImage(named: "N_company") ?? UIImage())
        squareImages.append(UIImage(named: "Y_company") ?? UIImage())
        
        passwordDecorator.delegate = self
        passwordDecorator.secureImagesArray = squareImages
        passwordDecorator.emptyImage = emptySquareImage
        passwordDecorator.successImage = successSquareImage
        passwordDecorator.unsuccessImage = unsuccessSquareImage
        passwordDecorator.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        passwordDecorator.shadow = DDPinCodeDecoratorShadowModel(color: UIColor.blue, opacity: 0.4, offSet: CGSize(width: 2, height: -2), radius: 5, scale: true)
        passwordDecorator.font = UIFont.systemFont(ofSize: 20)
        
        guard let squareView = passwordDecorator.view else { return }
        pinCodeContenView.addSubview(squareView)
        
        title = "Password is \"company\""
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
        
        passwordDecorator.view?.frame = pinCodeContenView.bounds
    }
    
}

extension PasswordViewController: DDPinCodeDecoratorOutput {
    
    func provideResult(module: DDPinCodeDecoratorProtocol, result: String) {
        if module === self.passwordDecorator {
            if result == "company" {
                module.showSuccess()
            } else {
                module.showUnsuccess()
                animate2(module: module)
            }
        }
    }
}

extension PasswordViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        var module: DDPinCodeDecoratorProtocol?
        
        if let animation = passwordDecorator.view?.layer.animation(forKey: addressOf(passwordDecorator)) {
            let animBasic = anim as CAAnimation
            let animationBasic = animation as CAAnimation
            if animBasic === animationBasic {
                module = passwordDecorator
            }
        }
        module?.clear()
    }
    
    func addressOf(_ obj: AnyObject) -> String {
        let addr = unsafeBitCast(obj, to: Int.self)
        return String(format: "%p", addr)
    }
}
