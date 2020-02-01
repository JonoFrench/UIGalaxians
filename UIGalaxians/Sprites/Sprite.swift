//
//  Sprite.swift
//  UIViewInvaders
//
//  Created by Jonathan French on 18/02/2019.
//  Copyright © 2019 Jaypeeff. All rights reserved.
//

import UIKit
import UISprites

class Bomb: UISprite, Animates {    
    let bombAnimations =
        [[UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)], [UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0), UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0), UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)]]
    
    init(pos:CGPoint,height:Int,width:Int) {
        super.init(pos: pos, height: height, width: width, animateArray: bombAnimations,frameWith:4,frameHeight:3,frames:2)
    }
}



class Bullet: UISprite, Animates {
    let bulletAnimations =
        [[UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)], [UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0), UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0), UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)]]
    init(pos:CGPoint,height:Int,width:Int) {
        super.init(pos: pos, height: height, width: width, animateArray: bulletAnimations,frameWith:4,frameHeight:3,frames:2)
    }
}



