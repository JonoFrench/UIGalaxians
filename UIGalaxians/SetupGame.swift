//
//  SetupGame.swift
//  UIViewInvaders
//
//  Created by Jonathan French on 28/01/2020.
//  Copyright © 2020 Jaypeeff. All rights reserved.
//

import UIKit
import UIAlphaNumeric
import UIHighScores

extension GalaxiansViewController {
    
       func setControls(){
           //Set up gesture recognizers for the controls
           let leftButtonGesture = UILongPressGestureRecognizer(target: self, action: #selector(leftPressed))
           leftButtonGesture.minimumPressDuration = 0
           leftButtonGesture.allowableMovement = 0
           leftButtonGesture.delegate = self
           leftButton?.addGestureRecognizer(leftButtonGesture)
           
           let rightButtonGesture = UILongPressGestureRecognizer(target: self, action: #selector(rightPressed))
           rightButtonGesture.minimumPressDuration = 0
           rightButtonGesture.allowableMovement = 0
           rightButtonGesture.delegate = self
           rightButton?.addGestureRecognizer(rightButtonGesture)
           
           let leftButtonTap = UITapGestureRecognizer(target: self, action: #selector(leftTapped))
           leftButtonTap.delegate = self
           leftButton?.addGestureRecognizer(leftButtonTap)
           
           let rightButtonTap = UITapGestureRecognizer(target: self, action: #selector(rightTapped))
           rightButtonTap.delegate = self
           rightButton?.addGestureRecognizer(rightButtonTap)
           
           
           
           let fireGesture = UITapGestureRecognizer(target: self, action: #selector(fire))
           fireGesture.numberOfTapsRequired = 1
           fireButton?.addGestureRecognizer(fireGesture)
           
           //Set the control layers
           leftButton?.clipsToBounds = true
           rightButton?.clipsToBounds = true
           leftButton?.layer.masksToBounds = true
           rightButton?.layer.masksToBounds = true
           leftButton?.layer.shouldRasterize = true
           rightButton?.layer.shouldRasterize = true
           
        leftButton?.backgroundColor = .clear
        rightButton?.backgroundColor = .clear
        fireButton?.backgroundColor = .clear
        baseLine?.backgroundColor = .clear

           if #available(iOS 11.0, *) {
               leftButton?.layer.cornerRadius = (leftButton?.frame.height)! / 2
               leftButton?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
           } else {
               //leftButton?.roundCorners(corners:[.topLeft,.bottomLeft], radius: (leftButton?.frame.height)! / 2)
               
               let path = UIBezierPath(roundedRect: leftButton!.bounds, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: (leftButton?.frame.width)! , height: (leftButton?.frame.height)! ))
               
               let maskLayer = CAShapeLayer()
               maskLayer.path = path.cgPath
               leftButton?.layer.mask = maskLayer
           }
           if #available(iOS 11.0, *) {
               rightButton?.layer.cornerRadius = (rightButton?.frame.height)! / 2
               rightButton?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
           } else {
               //rightButton?.roundCorners(corners:[.topRight,.bottomRight], radius: (rightButton?.frame.height)! / 2)
               
               let path = UIBezierPath(roundedRect: rightButton!.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: (rightButton?.frame.width)! , height: (rightButton?.frame.height)!))
               
               let maskLayer = CAShapeLayer()
               maskLayer.path = path.cgPath
               rightButton?.layer.mask = maskLayer
           }
           
           fireButton?.layer.borderWidth = 5
           fireButton?.layer.borderColor = UIColor.red.cgColor
           leftButton?.layer.borderWidth = 5
           leftButton?.layer.borderColor = UIColor.white.cgColor
           rightButton?.layer.borderWidth = 5
           rightButton?.layer.borderColor = UIColor.white.cgColor
           fireButton?.layer.cornerRadius = (fireButton?.frame.height)! / 2
           leftButton?.layer.setNeedsLayout()
       }
    
    
    
    func setScore() {
        if let sb = scoreBox {
            sb.clearSubviews()
            //sb.removeFromSuperview()
        let scoreString = String(format: "%06d", model.score)
        let alpha:UIAlphaNumeric = UIAlphaNumeric()
        scoreView = alpha.getStringView(string: scoreString, size: (scoreBox?.frame.size)!, fcol: .white, bcol: .blue)
        sb.addSubview(scoreView.charView!)
        }
        
    }
    
    func updateScore() {
        let alpha:UIAlphaNumeric = UIAlphaNumeric()
        let scoreString = String(format: "%06d", model.score)
        for (index, char) in scoreString.enumerated() {
            alpha.updateChar(char: char, viewArray: scoreView.charViewArray[index], fcol: .white, bcol: .blue)
        }
    }
    
    func setLevel() {
//        if levelView != nil {
//            levelView?.removeFromSuperview()
//        }
        if let lb = levelBox {
            lb.clearSubviews()
            //lb.removeFromSuperview()
        let levelString = "LEVEL\(model.level)"
        let alpha:UIAlphaNumeric = UIAlphaNumeric()
        let lv = alpha.getStringView(string: levelString, size: (levelBox?.frame.size)!, fcol: .white, bcol: .blue)
        levelView = lv.charView
        lb.addSubview(levelView!)
        }
    }
    
    func setLives() {
//        if livesView != nil {
//            livesView?.removeFromSuperview()
//        }
        if let lv = livesBox {
            
            lv.clearSubviews()
            //lv.removeFromSuperview()
        let levelString = "Lives\(model.lives)"
        let alpha:UIAlphaNumeric = UIAlphaNumeric()
        let lv = alpha.getStringView(string: levelString, size: (livesBox?.frame.size)!, fcol: .white, bcol: .blue)
        livesView = lv.charView
        livesBox?.addSubview(livesView!)
        }
    }
    
 
    
    func setBase() {
        if let base = base {
            base.spriteView?.removeFromSuperview()
        }
        model.leftMove = 0
        model.rightMove = 0
        base = Base(pos: CGPoint(x: 150, y: baseLineY), height: 40, width: 30)
        if let base = base {
            base.position = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height)
            base.spriteView?.alpha = 0
            base.spriteView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.addSubview((base.spriteView)!)
            base.animate()
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                base.spriteView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                base.spriteView?.alpha = 1
                base.spriteView?.center = CGPoint(x: self.view.frame.width / 2, y: self.baseLineY)
            }, completion: { (finished: Bool) in
                self.flashBase(flashes: 10)
               // self.model.gameState = .playing
                base.position = CGPoint(x: self.view.frame.width / 2, y: self.baseLineY)
            })
        }
    }
    
    func flashBase(flashes:Int){
        var f = flashes
        if f == 0 {
            self.model.gameState = .playing
            base?.spriteView?.isHidden  = false
            return
        } else {
            base?.spriteView?.isHidden = !(base?.spriteView!.isHidden)!
            f -= 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.flashBase(flashes: f)
            }
            
        }
    }
    
    func setInvaders() {
        invaders = []
        invaders.removeAll()
        var invaderType = 0
        var delay:Double = 0.0
        var step = viewWidth / 11
        let levelPos = model.level < 5 ? (model.level - 1) * invaderLevelIncrease : 100
        invaderStartY += levelPos
        for i in stride(from: step * 4, to: step * 8, by: step * 3) {
            invaderType = 0
            let invader:Invader = Invader(pos: CGPoint(x: viewWidth / 2, y: 20), height: invaderHeight, width: invaderWidth,invaderType: 3, invaderPoints: 100)
            model.numInvaders += 1
            invader.spriteView?.alpha = 0
            invader.spriteView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.addSubview(invader.spriteView!)
            invaders.append(invader)
            invader.animate()
            UIView.animate(withDuration: 1.0, delay: delay, options: [], animations: {
                invader.spriteView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                invader.spriteView?.alpha = 1
                invader.spriteView?.center = CGPoint(x: i, y: CGFloat(self.invaderStartY))
                invader.position = CGPoint(x: i, y: CGFloat(self.invaderStartY))
            }, completion: { (finished: Bool) in
                invader.originalPosition = invader.position
                invader.isArriving = false
            })
            delay += 0.020
            invaderType += 1

        }
        invaderStartY += 40
        
        for i in stride(from: step * 3, to: step * 9, by: step) {
            invaderType = 0
            let invader:Invader = Invader(pos: CGPoint(x: viewWidth / 2, y: 20), height: invaderHeight, width: invaderWidth,invaderType: 2, invaderPoints: 50)
            model.numInvaders += 1
            invader.spriteView?.alpha = 0
            invader.spriteView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.addSubview(invader.spriteView!)
            invaders.append(invader)
            invader.animate()
            UIView.animate(withDuration: 1.0, delay: delay, options: [], animations: {
                invader.spriteView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                invader.spriteView?.alpha = 1
                invader.spriteView?.center = CGPoint(x: i, y: CGFloat(self.invaderStartY))
                invader.position = CGPoint(x: i, y: CGFloat(self.invaderStartY))
            }, completion: { (finished: Bool) in
                invader.originalPosition = invader.position
                invader.isArriving = false

            })
            delay += 0.020
            invaderType += 1

        }
        invaderStartY += 50
        
        for i in stride(from: step * 2, to: step * 10, by: step) {
            invaderType = 0
            let invader:Invader = Invader(pos: CGPoint(x: viewWidth / 2, y: 20), height: invaderHeight, width: invaderWidth,invaderType: 1, invaderPoints: 30)
            model.numInvaders += 1
            invader.spriteView?.alpha = 0
            invader.spriteView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.addSubview(invader.spriteView!)
            invaders.append(invader)
            invader.animate()
            UIView.animate(withDuration: 1.0, delay: delay, options: [], animations: {
                invader.spriteView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                invader.spriteView?.alpha = 1
                invader.spriteView?.center = CGPoint(x: i, y: CGFloat(self.invaderStartY))
                invader.position = CGPoint(x: i, y: CGFloat(self.invaderStartY))
            }, completion: { (finished: Bool) in
 invader.originalPosition = invader.position
                invader.isArriving = false

            })
            delay += 0.020
            invaderType += 1

        }
        invaderStartY += 50
        
        step = viewWidth / 9
        for i in stride(from: step, to: step * 9, by: step) {
            invaderType = 0
            for z in stride(from: invaderStartY, to: invaderStartY + 150 , by: 40){
                let invader:Invader = Invader(pos: CGPoint(x: viewWidth / 2, y: 20), height: invaderHeight, width: invaderWidth,invaderType: 0, invaderPoints: 20)
                model.numInvaders += 1
                invader.spriteView?.alpha = 0
                invader.spriteView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.view.addSubview(invader.spriteView!)
                invaders.append(invader)
                invader.animate()
                UIView.animate(withDuration: 1.0, delay: delay, options: [], animations: {
                    invader.spriteView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    invader.spriteView?.alpha = 1
                    invader.spriteView?.center = CGPoint(x: i, y: CGFloat(z))
                    invader.position = CGPoint(x: i, y: CGFloat(z))
                }, completion: { (finished: Bool) in
                    invader.originalPosition = invader.position
                    invader.isArriving = false

                })
                delay += 0.020
                invaderType += 1
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.model.gameState = .playing
            //self.soundFX.invaderSound()
           //self.invaderSound()
        }
    }
    
   func setIntro(){
    if let i = introView {
    for v in i.subviews {
        v.removeFromSuperview()
    }
    }
    
    if let c = coverView {
    for v in c.subviews {
        v.removeFromSuperview()
    }
    }
    introView = UIView(frame: CGRect(x: 0, y: 0, width: (coverView?.frame.width)!, height: (coverView?.frame.height)!))

    highScore = UIHighScores.init(xPos: 0, yPos: highScoreYpos, width: (introView?.frame.width)!, height: ((coverView?.frame.height)!) - (highScoreHeight))


    highScore.titleBCol = .darkGray
    highScore.titleFCol = .cyan
    highScore.scoreFCol = .blue
    highScore.scoreBCol = .white
    highScore.drawScoreView()
        if let introView = introView, let coverView = coverView {
            let w = coverView.frame.width
            let h = coverView.frame.height
            coverView.backgroundColor = UIColor.black.withAlphaComponent(0.10)
            coverView.addSubview(introView)
            introView.backgroundColor = .clear
            let alpha:UIAlphaNumeric = UIAlphaNumeric()
            
            let title = UIView(frame: CGRect(x: 0, y: titleY, width: Int(w), height: titleHeight))
            title.addSubview(alpha.get(string: "RETRO", size: (title.frame.size), fcol: .cyan, bcol:.blue ))
            title.backgroundColor = .clear
            introView.addSubview(title)
            
            let subTitle = UIView(frame: CGRect(x: 0, y: titleY + titleHeight + 5, width: Int(w), height: subTitleHeight))
            subTitle.addSubview(alpha.get(string: "GALAXIANS", size: (subTitle.frame.size), fcol: .blue, bcol:.cyan ))
            subTitle.backgroundColor = .clear
            introView.addSubview(subTitle)
            
            invaderAttractStartY = titleY + titleHeight + 5 + Int(subTitle.frame.height) + 120
            print(invaderAttractStartY)
            let subTitle2 = UIView(frame: CGRect(x: 20, y: h - startTextY, width: w - 40, height: startTextHeight))
            subTitle2.addSubview(alpha.get(string: "TO PLAY", size: (subTitle2.frame.size), fcol: .orange, bcol:.purple ))
            subTitle2.backgroundColor = .clear
            introView.addSubview(subTitle2)
            
            let subTitle3 = UIView(frame: CGRect(x: 20, y: h - startTextY - startTextHeight - 5, width: w - 40, height: startTextHeight))
            subTitle3.addSubview(alpha.get(string: "PRESS FIRE", size: (subTitle3.frame.size), fcol: .orange, bcol:.purple ))
            subTitle3.backgroundColor = .clear
            introView.addSubview(subTitle3)
            introView.layoutIfNeeded()
            
            introView.addSubview(highScore.highScoreView)
            highScore.animateIn()
            let _ = highScore.xPositionsForSprites(spriteWidth: 60, offSet: 0, numberOfSprites: 3)
            let _ = highScore.xPositionsForSprites(spriteWidth: 60, offSet: 90, numberOfSprites: 3)
            let _ = highScore.xPositionsForSprites(spriteWidth: 60, offSet: 0, numberOfSprites: 4)
            let _ = highScore.xPositionsForSprites(spriteWidth: 30, offSet: 90, numberOfSprites: 4)
        }
        setIntroInvaders()
        self.view.bringSubviewToFront(coverView!)
    }
    
    func setIntroInvaders() {
               invaders.removeAll()
               var invaderType = 0

               var delay:Double = 0.0
               var step = viewWidth / 11
               //let levelPos = model.level < 5 ? model.level * invaderLevelIncrease : 100
               for i in stride(from: step * 4, to: step * 8, by: step * 3) {
                   invaderType = 0
                let invader:Invader = Invader(pos: CGPoint(x: viewWidth / 2, y: 20), height: invaderHeight, width: invaderWidth,invaderType: 3, invaderPoints: 100)
                   model.numInvaders += 1
                   invader.spriteView?.alpha = 0
                   invader.spriteView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                   self.view.addSubview(invader.spriteView!)
                   invaders.append(invader)
                   invader.animate()
                   UIView.animate(withDuration: 1.0, delay: delay, options: [], animations: {
                       invader.spriteView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                       invader.spriteView?.alpha = 1
                       invader.spriteView?.center = CGPoint(x: i, y: CGFloat(self.invaderAttractStartY))
                       invader.position = CGPoint(x: i, y: CGFloat(self.invaderAttractStartY))
                   }, completion: { (finished: Bool) in
                       invader.originalPosition = invader.position
                   })
                   delay += 0.020
                   invaderType += 1

               }
               invaderAttractStartY += 40
               
               for i in stride(from: step * 3, to: step * 9, by: step) {
                   invaderType = 0
                   let invader:Invader = Invader(pos: CGPoint(x: viewWidth / 2, y: 20), height: invaderHeight, width: invaderWidth,invaderType: 2, invaderPoints: 50)
                   model.numInvaders += 1
                   invader.spriteView?.alpha = 0
                   invader.spriteView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                   self.view.addSubview(invader.spriteView!)
                   invaders.append(invader)
                   invader.animate()
                   UIView.animate(withDuration: 1.0, delay: delay, options: [], animations: {
                       invader.spriteView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                       invader.spriteView?.alpha = 1
                       invader.spriteView?.center = CGPoint(x: i, y: CGFloat(self.invaderAttractStartY))
                       invader.position = CGPoint(x: i, y: CGFloat(self.invaderAttractStartY))
                   }, completion: { (finished: Bool) in
                       invader.originalPosition = invader.position

                   })
                   delay += 0.020
                   invaderType += 1

               }
               invaderAttractStartY += 50
               
               for i in stride(from: step * 2, to: step * 10, by: step) {
                   invaderType = 0
                   let invader:Invader = Invader(pos: CGPoint(x: viewWidth / 2, y: 20), height: invaderHeight, width: invaderWidth,invaderType: 1, invaderPoints: 30)
                   model.numInvaders += 1
                   invader.spriteView?.alpha = 0
                   invader.spriteView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                   self.view.addSubview(invader.spriteView!)
                   invaders.append(invader)
                   invader.animate()
                   UIView.animate(withDuration: 1.0, delay: delay, options: [], animations: {
                       invader.spriteView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                       invader.spriteView?.alpha = 1
                       invader.spriteView?.center = CGPoint(x: i, y: CGFloat(self.invaderAttractStartY))
                       invader.position = CGPoint(x: i, y: CGFloat(self.invaderAttractStartY))
                   }, completion: { (finished: Bool) in
        invader.originalPosition = invader.position

                   })
                   delay += 0.020
                   invaderType += 1

               }
               invaderAttractStartY += 50
               
               step = viewWidth / 9
               for i in stride(from: step, to: step * 9, by: step) {
                   invaderType = 0
                   for z in stride(from: invaderAttractStartY, to: invaderAttractStartY + 150, by: 50){
                       let invader:Invader = Invader(pos: CGPoint(x: viewWidth / 2, y: 20), height: invaderHeight, width: invaderWidth,invaderType: 0, invaderPoints: 20)
                       model.numInvaders += 1
                       invader.spriteView?.alpha = 0
                       invader.spriteView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                       self.view.addSubview(invader.spriteView!)
                       invaders.append(invader)
                       invader.animate()
                       UIView.animate(withDuration: 1.0, delay: delay, options: [], animations: {
                           invader.spriteView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                           invader.spriteView?.alpha = 1
                           invader.spriteView?.center = CGPoint(x: i, y: CGFloat(z))
                           invader.position = CGPoint(x: i, y: CGFloat(z))
                       }, completion: { (finished: Bool) in
                           invader.originalPosition = invader.position

                       })
                       delay += 0.020
                       invaderType += 1
                   }
               }
    }
    
    func removeIntroInvaders(){
        for invader in invaders {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                invader.spriteView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                invader.spriteView?.alpha = 1
                invader.spriteView?.center = CGPoint(x: self.viewWidth / 2, y: 20)
            }, completion: { (finished: Bool) in
                invader.spriteView?.removeFromSuperview()
                invader.spriteView? = UIView()
                invader.stopAnimating = true
            })
        }
        
        //        if let hiscore = highScore {
        highScore.removeHighscore()
        //        }
    }
    
}
