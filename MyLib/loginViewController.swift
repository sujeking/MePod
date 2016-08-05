//
//  loginViewController.swift
//  想嘻嘻嘻嘻嘻嘻嘻嘻嘻
//
//  Created by  黎明 on 16/8/5.
//  Copyright © 2016年 suzw. All rights reserved.
//

import UIKit

class loginViewController: UIViewController,UITextFieldDelegate{
    
     @IBOutlet weak var userNameTextField: UITextField!
     @IBOutlet weak var userPassTextField: UITextField!
    var lineLayerName: CALayer!
    var lineLayerPass: CALayer!
    var lineLayerTransfer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupSubViews()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupSubViews() {
        self.userNameTextField.delegate = self
        self.userPassTextField.delegate = self
        
        self.layerName()
        self.layerPass()
        self.layerTransfer()
        
        self.view.layer.addSublayer(self.lineLayerName)
        self.view.layer.addSublayer(self.lineLayerPass)
        self.view.layer.addSublayer(self.lineLayerTransfer)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isEqual(self.userNameTextField) {
            
            let x: CGFloat     = CGRectGetMinX(self.userNameTextField.frame)
            let y: CGFloat     = CGRectGetMaxY(self.userNameTextField.frame) + 5
            let width: CGFloat  = CGRectGetWidth(self.userNameTextField.frame)
            let height: CGFloat = 1.0
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)
            self.lineLayerName.frame = CGRectMake(x, y, width, height)
            CATransaction.commit()
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    
        if textField.isEqual(self.userNameTextField) {
            let x: CGFloat     = CGRectGetMaxX(self.userNameTextField.frame)
            let y: CGFloat     = CGRectGetMaxY(self.userNameTextField.frame) + 5
            let height: CGFloat = 1.0
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)
            self.lineLayerName.frame = CGRectMake(x, y, 0, height)
            CATransaction.commit()
            
            NSThread.sleepForTimeInterval(0.5)
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)
            self.lineLayerTransfer.strokeEnd = 1
            CATransaction.commit()
            
            NSThread.sleepForTimeInterval(0.5)
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)
            self.lineLayerTransfer.strokeStart = 1
            CATransaction.commit()

            
            
            
            
            
            let xp: CGFloat     = CGRectGetMinX(self.userPassTextField.frame)
            let yp: CGFloat     = CGRectGetMaxY(self.userPassTextField.frame) + 5
            let width: CGFloat  = CGRectGetWidth(self.userPassTextField.frame)
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)
            self.lineLayerPass.frame = CGRectMake(xp, yp, width, height)
            CATransaction.commit()
        }
        
        if textField.isEqual(self.userPassTextField) {
            
            let xp: CGFloat     = CGRectGetMinX(self.userPassTextField.frame)
            let yp: CGFloat     = CGRectGetMaxY(self.userPassTextField.frame) + 5
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)
            self.lineLayerPass.frame = CGRectMake(xp, yp, 0, 1)
            self.lineLayerTransfer.strokeStart = 1
            CATransaction.commit()
            
            
            let x: CGFloat     = CGRectGetMinX(self.userNameTextField.frame)
            let y: CGFloat     = CGRectGetMaxY(self.userNameTextField.frame) + 5
            let width: CGFloat  = CGRectGetWidth(self.userNameTextField.frame)
            let height: CGFloat = 1.0
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(1)
            self.lineLayerName.frame = CGRectMake(x, y, width, height)
            CATransaction.commit()
        }

        
        
        
        return true
    }
    
    func transferPath() -> UIBezierPath{
        let transferPath = UIBezierPath()
        transferPath.moveToPoint(CGPointMake(0, 0))
        transferPath.addCurveToPoint(CGPointMake(26.852, 26.974), controlPoint1:CGPointMake(14.83, 0), controlPoint2:CGPointMake(26.852, 12.077))
        transferPath.addCurveToPoint(CGPointMake(0, 53.949), controlPoint1:CGPointMake(26.852, 41.872), controlPoint2:CGPointMake(14.83, 53.949))
        
        return transferPath;
    }
    
    func layerName() {
        
        lineLayerName = CALayer.init()
        let x: CGFloat     = CGRectGetMinX(self.userNameTextField.frame)
        let y: CGFloat     = CGRectGetMaxY(self.userNameTextField.frame) + 5
        let height: CGFloat = 1.0
        lineLayerName.frame = CGRectMake(x, y, 0, height)
        lineLayerName.backgroundColor = UIColor.whiteColor().CGColor
    }
    
    func layerPass() {
        lineLayerPass = CALayer.init()
        let x: CGFloat     = CGRectGetMaxX(self.userPassTextField.frame)
        let y: CGFloat     = CGRectGetMaxY(self.userPassTextField.frame) + 5
        let height: CGFloat = 1.0
        lineLayerPass.frame = CGRectMake(x, y, 0, height)
        lineLayerPass.backgroundColor = UIColor.redColor().CGColor
    }
    
    func layerTransfer() {
        lineLayerTransfer = CAShapeLayer.init()
        let x: CGFloat     = CGRectGetMaxX(self.userPassTextField.frame)
        let y: CGFloat     = CGRectGetMaxY(self.userNameTextField.frame) + 6
        lineLayerTransfer.frame = CGRectMake(x, y, 30, 55)
        lineLayerTransfer.strokeColor = UIColor.redColor().CGColor
        lineLayerTransfer.fillColor = nil
        lineLayerTransfer.path = self.transferPath().CGPath
        lineLayerTransfer.strokeEnd = 0
    }


}
