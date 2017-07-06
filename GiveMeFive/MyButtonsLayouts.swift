//
//  MyButtonsLayouts.swift
//  GiveMeFive 1.4.0
//
//  Created by Marco D'Agostino on 06/07/17.
//

import UIKit

@IBDesignable
class MyButtonsLayouts: UIButton {

   @IBInspectable var radius: CGFloat {
      
      get {
         return self.layer.cornerRadius
      }
      
      set (newValue) {
         self.layer.cornerRadius = newValue
      }
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   
      setMyButtonsLayout (value: radius)
   }
   
   func setMyButtonsLayout (value: CGFloat) {
    
      self.layer.cornerRadius = value
      self.layer.shadowColor = UIColor.black.cgColor
      self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
      self.layer.shadowRadius = 10.0
      self.layer.shadowOpacity = 0.8

   }

}
