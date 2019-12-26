//
//  ViewController.swift
//  DDPinCodeDecoratorExample
//
//  Created by Dotsenko  on 19.12.2019.
//  Copyright © 2019 Dotsenko . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "swamp4")!)
        view.addLightBlur()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
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
