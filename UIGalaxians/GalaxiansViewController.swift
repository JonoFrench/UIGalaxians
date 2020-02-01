//
//  ViewController.swift
//  UIViewInvaders
//
//  Created by Jonathan French on 18/02/2019.
//  Copyright © 2019 Jaypeeff. All rights reserved.
//

import UIKit
import UIAlphaNumeric
import UISprites
import UIHighScores

class GalaxiansViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var leftButton: UIView?
    @IBOutlet weak var rightButton: UIView?
    @IBOutlet weak var fireButton: UIView?
    @IBOutlet weak var baseLine: UIView?
    @IBOutlet weak var coverView: UIView?
    @IBOutlet weak var scoreBox: UIView?
    @IBOutlet weak var levelBox: UIView?
    @IBOutlet weak var livesBox: UIView?
    
    @IBOutlet weak var leftBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var leftBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var rightBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var rightBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var fireBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var fireBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scoreHeight: NSLayoutConstraint!
    @IBOutlet weak var scoreWidth: NSLayoutConstraint!
    
    @IBOutlet weak var levelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var levelWidth: NSLayoutConstraint!
    @IBOutlet weak var livesHeight: NSLayoutConstraint!
    @IBOutlet weak var livesWidth: NSLayoutConstraint!
    
    @IBOutlet weak var baseLineBottom: NSLayoutConstraint!
    
    @IBOutlet weak var levelTop: NSLayoutConstraint!
    
    @IBOutlet weak var scoreTop: NSLayoutConstraint!
    
    @IBOutlet weak var livesTop: NSLayoutConstraint!
    var titleY = 20
    var titleHeight = 90
    var subTitleHeight = 60
    var startTextHeight:CGFloat = 30.0
    var startTextY:CGFloat = 50.0
    var highScoreYpos:CGFloat = 192
    var highScoreHeight:CGFloat = 300
    
    var siloBaseLine:CGFloat = 120
    
    var invaderPosY = 300
    var invaderFinishY = 600
    var invaderStride = 60
    var invaderWidth = 30
    var invaderHeight = 25
    var introInvaders:CGFloat = 6
    var introView:UIView?
    var gameoverView:UIView?
    var levelView:UIView?
    var livesView:UIView?
    var invaderStartY = 140
    var invaderAttractStartY = 0
    var invaderLevelIncrease = 20
    
    var model:GalaxiansModel = GalaxiansModel()
    var base:Base?
    var baseLineY: CGFloat = 0
    var viewWidth: CGFloat = 0
    var viewHeight: CGFloat = 0
    var bullet:Bullet?
    var invaders:[Invader] = []
    var bombs:[Bomb] = []
    var soundFX:SoundFX = SoundFX()
    var scoreView:StringViewArray = StringViewArray()
    var highScore:UIHighScores = UIHighScores()
    var loopPoints = 80
    var leftCirclePoints:[CGPoint] = []
    var rightCirclePoints:[CGPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the model
        model.viewController = self
        self.view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.bringSubviewToFront(coverView!)
        let displayLink:CADisplayLink = CADisplayLink(target: self, selector: #selector(refreshDisplay))
        displayLink.add(to: .main, forMode:.common)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        if !model.layoutSet { // only want to do this once.
            model.layoutSet = true
            baseLineY = ((baseLine?.center.y)!) - 15
            viewWidth = self.view.frame.width
            viewHeight = self.view.frame.height
            leftCirclePoints = getLeftCirclePoints(centerPoint:CGPoint(x: 0 , y: 0 ), radius: 40.0, n: loopPoints)
            rightCirclePoints = getRightCirclePoints(centerPoint:CGPoint(x: 0 , y: 0 ), radius: 40.0, n: loopPoints)
            
            setScore()
            setLevel()
            setLives()
            setControls()
            //setStars()
            setIntro()
        }
    }
    
    func setConstraints() {
        if self.view.frame.height < 600 {
            leftBtnHeight.constant = 75
            leftBtnWidth.constant = 75
            rightBtnHeight.constant = 75
            rightBtnWidth.constant = 75
            fireBtnWidth.constant = 75
            fireBtnHeight.constant = 75
            
            scoreHeight.constant = 25
            livesHeight.constant = 25
            levelHeight.constant = 25
            
            scoreWidth.constant = 80
            livesWidth.constant = 80
            levelWidth.constant = 80
            
            baseLineBottom.constant = 80
            livesTop.constant = -10
            scoreTop.constant = -10
            levelTop.constant = -10
            
            titleY = 0
            titleHeight = 70
            subTitleHeight = 50
            startTextHeight = 25
            startTextY = 30
            
            highScoreYpos = 125
            highScoreHeight = 180
            
            invaderPosY = 220
            invaderFinishY = 420
            invaderStride = 50
            //invaderSize = 35
            introInvaders = 5
            
            invaderStartY = 60
            invaderLevelIncrease = 15
            view.setNeedsLayout()
        }
    }
    
    
    
    
    fileprivate func removeWonInvaders(){
        
        
        let _ = invaders.filter{ !$0.isDead }.map{ invader in UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            invader.spriteView?.transform = CGAffineTransform(scaleX: 3.1, y: 3.1)
            invader.spriteView?.alpha = 0
            invader.spriteView?.center = CGPoint(x: self.viewWidth / 2, y: self.viewHeight  )
        }, completion: { (finished: Bool) in
            invader.spriteView?.removeFromSuperview()
        })}
        
        model.gameState = .ending
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.model.gameState = .gameOver
            self.resetGame()
        }
    }
    
    fileprivate func setGameOverView(){
        for b in bombs {
            b.spriteView?.removeFromSuperview()
        }
        let alpha:UIAlphaNumeric = UIAlphaNumeric()
        gameoverView = UIView(frame: CGRect(x: 0, y: viewHeight / 2, width: (coverView?.frame.width)!, height: 40))
        if let gameoverView = gameoverView {
            let gov = UIView(frame: CGRect(x: 0, y: 0, width: gameoverView.frame.width, height: gameoverView.frame.height))
            gov.addSubview(alpha.get(string: "GAME OVER", size: (gov.frame.size), fcol: .red, bcol:.yellow ))
            gov.backgroundColor = .clear
            gameoverView.alpha = 0
            gameoverView.addSubview(gov)
            gameoverView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: CGFloat.pi)
            self.view.addSubview(gameoverView)
            UIView.animate(withDuration: 0.5, delay: 0.25, options: [], animations: {
                gameoverView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).rotated(by: 0)
                gameoverView.alpha = 1
            }, completion: { (finished: Bool) in
                UIView.animate(withDuration: 0.5, delay: 3.0, options: [], animations: {
                    gameoverView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: CGFloat.pi)
                    gameoverView.alpha = 0
                }, completion: { (finished: Bool) in
                    if (self.highScore.isNewHiScore(score: self.model.score)) {
                        self.introView = UIView(frame: CGRect(x: 0, y: 0, width: (self.coverView?.frame.width)!, height: (self.coverView?.frame.height)!))
                        self.introView?.alpha = 0
                        self.model.gameState = .hiScore
                        self.highScore.showNewHiScore(frame: CGRect(x: 0, y: 100, width: (self.coverView?.frame.width)!, height: 480))
                        self.introView?.addSubview(self.highScore.newHighScoreView)
                        self.coverView?.alpha = 1
                        self.coverView?.addSubview(self.introView!)
                        self.introView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: CGFloat.pi)
                        UIView.animate(withDuration: 0.5, delay: 0.25, options: [], animations: {
                            self.introView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).rotated(by: 0)
                            self.introView?.alpha = 1
                        }, completion: { (finished: Bool) in
                            
                        })
                    } else {
                        
                        self.coverView?.alpha = 1
                        self.model.gameState = .starting
                        gameoverView.removeFromSuperview()
                        self.setIntro()
                    }
                })
            })
        }
    }
    
    // reset the UI
    fileprivate func resetGame() {
        setGameOverView()
        for i in invaders {
            if let isv = i.spriteView {
                isv.removeFromSuperview()
            }
        }
        invaders.removeAll()
        
        
        
        for b in bombs {
            if let bsv = b.spriteView {
                bsv.removeFromSuperview()
            }
        }
        bombs.removeAll()
        
        if let bul = bullet?.spriteView {
            bul.removeFromSuperview()
        }
        model.bulletFired = false
        
        base?.spriteView?.removeFromSuperview()
        base = nil
    }
    
    fileprivate func nextLevel() {
        model.gameState = .loading
        
        setInvaders()
    }
    
    fileprivate func cleanUpBeforeNextLevel(){
        for b in bombs {
            if let bsv = b.spriteView {
                bsv.removeFromSuperview()
            }
        }
        bombs.removeAll()
        
    }
    
    fileprivate func startGame() {
        self.removeIntroInvaders()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.highScore.highScoreView.alpha = 0
            self.coverView!.alpha = 0
        }, completion: { (finished: Bool) in
            self.introView?.removeFromSuperview()
            self.model.reset()
            self.setInvaders()
            self.setBase()
        })
    }
    
    
    
    fileprivate func moveBase() {
        if let base = base {
            let x = base.position.x
            let y = base.position.y
            if model.leftMove > 0 && x > 0 {
                base.position = CGPoint(x: x - model.baseSpeed, y: y)
            } else if model.rightMove > 0 && x < self.view.frame.width {
                base.position = CGPoint(x: x + model.baseSpeed, y: y)
            }
        }
    }
    
    fileprivate func checkBullets() {
        if model.bulletFired {
            if let bullet = bullet, let spriteView = bullet.spriteView {
                let pos = bullet.position
                if pos.y <= 0 {
                    model.bulletFired = false
                    bullet.spriteView?.removeFromSuperview()
                } else {
                    bullet.position = CGPoint(x: pos.x, y: pos.y - 8)
                    for inv in invaders {
                        if inv.checkHit(pos: spriteView.center) == true {
                            inv.startAnimatingNow()
                            self.soundFX.hitSound()
                            spriteView.removeFromSuperview()
                            model.bulletFired = false
                            if inv.isBombing {
                                model.score += inv.invaderPoints * 2
                                //fadeOutStringAt(point: inv.position,string: "200")
                            }
                            else {
                                model.score += inv.invaderPoints
                            }
                            
                            if inv.isConvoy {
                                let c = inv.convoyInvaders.filter({ $0.isDead == true}).count
                                if c >= 2 {
                                    model.score += 800
                                    fadeOutStringAt(point: inv.position,string: "800")
                                } else if c == 1 {
                                    model.score += 200
                                    fadeOutStringAt(point: inv.position,string: "200")
                                }
                                inv.isConvoy = false
                                inv.convoyInvaders.removeAll()
                                
                            }
                            model.deadCount += 1
                        }
                    }
                }
                
            }
        }
    }
    
    func fadeOutStringAt(point:CGPoint,string:String){
        let alpha = UIAlphaNumeric.init()
        let stringView = alpha.get(string: string, size: CGSize(width: 60, height: 40), fcol: .yellow, bcol:.clear )
        stringView.center = point
        self.view.addSubview(stringView)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            stringView.alpha = 0.0
        }, completion: { (finished: Bool) in
            stringView.removeFromSuperview()
         })
        
    }
    
    fileprivate func checkBombs() {
        
        for bomb in bombs {
            if bomb.isDying || bomb.isDead {continue}
            
            if bomb.position.y > viewHeight - 10 {
                bomb.isDying = true
                continue
            }
            bomb.move(x: 0, y: model.bombSpeed)
            if model.gameState == .playing {
                if let b = base {
                    if 1 == 2 {
                        //                        if b.checkHit(pos:bomb.position) {
                        bomb.isDying = true
                        model.gameState = .dieing
                        self.soundFX.baseHitSound()
                        self.model.lives -= 1
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            //self.model.lives -= 1
                            if self.model.lives == 0 {
                                self.model.gameState = .ending
                                self.removeWonInvaders()
                                
                            } else {
                                self.setBase()
                            }
                        }
                        continue
                    }
                }
            }
            
        }
    }
    
    fileprivate func checkIntroInvaders(){
        for inv in invaders {
            // rotate the odd one
            if Int.random(in: 0...1000) == 1 {
                inv.rotateMe()
            }
            
            if model.invaderXSpeed > 0 {
                if inv.position.x > viewWidth - 10 {
                    model.invaderXSpeed = -2
                }
            } else {
                if inv.position.x < 10 {
                    model.invaderXSpeed = 2
                }
            }
        }
    }
    
    fileprivate func checkInvaders() {
        for inv in invaders {
            if inv.isDead {continue}
            //if Int.random(in: 0...model.bombRandomiser) == 1 && model.gameState == .playing {
            if Int.random(in: 0...5000) == 1 && model.gameState == .playing {
                diveBombMe(inv: inv)
                //dropBomb(pos: inv.position)
                //inv.rotateMe()
            }
            if inv.isBombing && Int.random(in: 0...50) == 1 {
                dropBomb(pos: inv.position)
            }
            // use the amount of dead invaders to increase the speed of the remaining
            // so the game gets harder.
            
            if model.invaderXSpeed > 0 {
                if inv.position.x > viewWidth - 10 && !inv.isBombing {
                    model.invaderXSpeed = -1
                    //model.invaderXSpeed = -2 - (model.deadCount / 6)
                    //model.invaderYSpeed = 5 + (model.deadCount / 6)
                    break
                }
            } else {
                if inv.position.x < 10 && !inv.isBombing {
                    model.invaderXSpeed = 1
                    //model.invaderYSpeed = 5 + (model.deadCount / 6)
                    break
                }
            }
            if inv.isBombing {
                if inv.position.x > viewWidth  {
                    inv.diveX.negate()
                } else {
                    if inv.position.x < 0 {
                        inv.diveX.negate()
                    }
                }
            }
            
            if model.gameState != .ending {
                //  if let b = base, let i = inv.spriteView {
                //                    if i.frame.minY > baseLineY - 30 {
                //                        model.gameState = .ending
                //                        removeWonInvaders()
                //                        break
                //                    }
                //                    if b.checkHit(pos: (i.frame)) {
                //                        model.gameState = .ending
                //                        removeWonInvaders()
                //                        self.soundFX.baseHitSound()
                //                        break
                //                    }
                //    }
            }
            
        }
    }
    
    func moveInvaders() {
        
        for inv in invaders {
            if inv.isDead {continue}
            
            if !inv.isBombing {
                inv.move(x: model.invaderXSpeed, y: model.invaderYSpeed)
            } else {
                
                inv.returnPosition.x = inv.returnPosition.x + CGFloat(model.invaderXSpeed)
                inv.returnPosition.y = inv.returnPosition.y + CGFloat(model.invaderYSpeed)
                
                if inv.rotatePoint > rightCirclePoints.count - 2 {
                    if inv.position.y > self.viewHeight {
                        inv.isBombing = false
                        inv.isConvoy = false
                        inv.convoyInvaders.removeAll()
                        
                        inv.position = CGPoint(x: self.viewWidth / 2, y: 10)
                        // let inv = $0
                        UIView.animate(withDuration: 2.0, delay: 0.0, options: [], animations: {
                            inv.startAnimating()
                            inv.rotateMeTo(angle: 0.0,duration:0.5)
                            inv.position = inv.returnPosition
                        }, completion: { (finished: Bool) in
                            
                        })
                    } else {
                        
                        inv.move(x: inv.diveX, y: inv.diveY)
                    }
                } else {
                    if inv.rotateRight {
                        inv.position.x = inv.originalPosition.x + rightCirclePoints[inv.rotatePoint].x - CGFloat(invaderWidth)
                        inv.position.y = inv.originalPosition.y + rightCirclePoints[inv.rotatePoint].y - CGFloat(invaderHeight)
                    } else {
                        inv.position.x = inv.originalPosition.x - leftCirclePoints[inv.rotatePoint].x - CGFloat(invaderWidth)
                        inv.position.y = inv.originalPosition.y - leftCirclePoints[inv.rotatePoint].y - CGFloat(invaderHeight)
                        
                    }
                    //$0.move(x: Int($0.bombingOffsets[$0.rotatePoint].x), y: Int($0.bombingOffsets[$0.rotatePoint].y))
                    inv.rotatePoint += 1
                }
                
                
            }
        }
        
        
        if model.invaderYSpeed > 0 { model.invaderYSpeed = 0}
    }
    
    
    func dropBomb(pos:CGPoint) {
        guard model.gameState == .playing else {
            return
        }
        let bomb = Bomb(pos: pos, height: 18, width: 6)
        bomb.position = pos
        self.view.addSubview(bomb.spriteView!)
        bombs.append(bomb)
        bomb.startAnimating()
    }
    
    func diveBombMe(inv:Invader){
        guard !inv.isBombing else {
            return
        }
        if inv.position.x >= (viewWidth / 2) { // dive left
            var rx = 0
            var ry = 0
            if Int.random(in: 1...2) == 1 && inv.invaderType != 3  { //if its going to be a convoy then less shallo dive
                rx = -3
                ry = 4
            } else {
                rx = -4
                ry = 3
            }
            diveMe(inv:inv,x:rx,y:ry,rRight:false)
            if inv.invaderType == 3 { //Convoy
                for i in 5...7 { //&& Int.random(in: 0...10) == 1
                    if !invaders[i].isBombing && !invaders[i].isDead && Int.random(in: 1...2) == 1 {
                        inv.isConvoy = true
                        inv.convoyInvaders.append(invaders[i])
                        diveMe(inv:invaders[i],x:rx,y:ry,rRight:false)
                    }
                }
            }
            
            print("Left \(inv.position) start \(leftCirclePoints[0])")
            
        } else { // dive right
            
            var rx = 0
            var ry = 0
            if Int.random(in: 1...2) == 1 && inv.invaderType != 3 {
                rx = 3
                ry = 4
            } else {
                rx = 4
                ry = 3
            }
            diveMe(inv:inv,x:rx,y:ry,rRight:true)
            if inv.invaderType == 3 {
                for i in 2...4 {
                    if !invaders[i].isBombing && !invaders[i].isDead && Int.random(in: 1...2) == 1  {
                        inv.isConvoy = true
                        inv.convoyInvaders.append(invaders[i])
                        diveMe(inv:invaders[i],x:rx,y:ry,rRight:true)
                    }
                }
            }
            print("Right \(inv.position) start \(rightCirclePoints[0])")
        }
    }
    
    func diveMe(inv:Invader,x:Int,y:Int,rRight:Bool) {
        self.view.bringSubviewToFront(inv.spriteView!)
        inv.isBombing = true
        inv.rotatePoint = 0
        inv.originalPosition = inv.position
        inv.returnPosition = inv.position
        inv.stopAnimating = true
        
        inv.rotateRight = rRight
        inv.diveY = y
        inv.diveX = x
        inv.rotateMeTo(angle: 179.0,duration:0.5)
        
    }
    
    //    func createCurvePath(initialPos:CGPoint) -> UIBezierPath {
    //        let path = UIBezierPath()
    //        path.move(to: CGPoint(x: initialPos.x, y: initialPos.y))
    //        path.addQuadCurve(to: CGPoint(x: initialPos.x - 100, y: initialPos.y ), controlPoint: CGPoint(x: initialPos.x - 45, y: initialPos.y - 45) )
    //        return path
    //    }
    //
    //    func quadBezier(pos: Double, start: Double, con: Double, end: Double) -> Double {
    //        let t_ = (1.0 - pos)
    //        let tt_ = t_ * t_
    //        let tt = pos * pos
    //
    //        return Double(start * tt_) + Double(2.0 * con * t_ * pos) + Double(end * tt)
    //    }
    
    func getRightCirclePoints(centerPoint point: CGPoint, radius: CGFloat, n: Int)->[CGPoint] {
        let result: [CGPoint] = stride(from: 0.0, to: 360.0, by: Double(360 / n)).map {
            let bearing = CGFloat($0) * .pi / 180
            let x = point.x + radius * cos(bearing)
            let y = point.y + radius * sin(bearing)
            return CGPoint(x: x, y: y)
        }
        let a = result
        let start1 = 0
        let end1 = (n / 8)
        //        let start = n / 4
        //        let end = ((n / 4) * 3) + (n / 8)
        let start2 = ((n / 4) * 2) //+ (n / 8)
        let end2 = n
        print("Right start \(start1) end \(end1)")
        let a1 = Array(a[start1 ..< end1])
        let a2 = Array(a[start2 ..< end2])
        return Array(a1.reversed()) + Array(a2.reversed())
        //return Array(a[(n/2) ..< n])
    }
    
    func getLeftCirclePoints(centerPoint point: CGPoint, radius: CGFloat, n: Int)->[CGPoint] {
        let result: [CGPoint] = stride(from: 0.0, to: 360.0, by: Double(360 / n)).map {
            let bearing = CGFloat($0) * .pi / 180
            let x = point.x + radius * cos(bearing)
            let y = point.y + radius * sin(bearing)
            return CGPoint(x: x, y: y)
        }
        let a = result
        // print(a)
        let start = (n / 8)
        let end = n - (n / 4)
        print("Left start \(start) end \(end)")
        //        let a1 = Array(a[start ..< end].reversed())
        //        let a2 = Array(a[0 ..< n / 2].reversed())
        return Array(a[start ..< end])
        // return Array(a[(n/2) ..< n])
    }
    //Game loop
    // refreshDisplay is called from the runloop and should be called every screen refresh cycle
    
    @objc func refreshDisplay() {
        
        switch model.gameState {
        case .starting:
            moveInvaders()
            checkIntroInvaders()
            break
        case .loading:
            break
        case.nextLevel:
            self.model.gameState = .loading
            cleanUpBeforeNextLevel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.nextLevel()
            }
            break
        case .dieing:
            checkBullets()
            checkBombs()
            checkInvaders()
            moveInvaders()
            break
        case .ending:
            checkBullets()
            checkBombs()
            checkInvaders()
            //moveInvaders()
            break
        case .playing:
            moveBase()
            moveInvaders()
            checkBullets()
            checkInvaders()
            checkBombs()
            break
        case .gameOver:
            //highScore?.newHighScore(newScore: model.score)
            break
        case .hiScore:
            break
        }
    }
    
    //Controls
    
    @objc func leftPressed(gesture:UILongPressGestureRecognizer) {
        guard model.gameState == .playing else {
            return
        }
        if gesture.state == .began {
            model.leftMove = model.baseSpeed
        } else if gesture.state == .ended {
            model.leftMove = 0
        }
    }
    
    @objc func leftTapped(gesture:UIGestureRecognizer) {
        guard model.gameState == .hiScore else {
            return
        }
        // if let hiscore = highScore {
        highScore.charDown()
        // }
    }
    
    @objc func rightTapped(gesture:UIGestureRecognizer) {
        guard model.gameState == .hiScore else {
            return
        }
        //if let hiscore = highScore {
        highScore.charUp()
        //}
    }
    
    
    @objc func rightPressed(gesture:UILongPressGestureRecognizer) {
        guard model.gameState == .playing else {
            return
        }
        if gesture.state == .began {
            model.rightMove = model.baseSpeed
        } else if gesture.state == .ended {
            model.rightMove = 0
        }
    }
    
    @objc func fire(gesture:UITapGestureRecognizer) {
        guard model.bulletFired == false && model.gameState != .loading else {
            return
        }
        
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        if model.gameState == .hiScore {
            if let introView = introView {
                highScore.alphaPos += 1
                if (highScore.alphaPos == 3) {
                    highScore.addScores(score: model.score)
                    
                    UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
                        introView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: CGFloat.pi)
                        introView.alpha = 0
                    }, completion: { (finished: Bool) in
                        
                        self.coverView?.alpha = 1
                        self.model.gameState = .starting
                        introView.removeFromSuperview()
                        self.setIntro()
                    })
                } else {
                    highScore.hilightChar()
                    
                }
            }
        }
        else if model.gameState == .starting || model.gameState == .gameOver {
            model.gameState = .loading
            self.soundFX.startSound()
            
            startGame()
        } else if model.gameState != .ending && model.gameState != .dieing {
            if let bsv = base?.spriteView {
                bullet = Bullet(pos: bsv.center, height: 18, width: 6)
                bullet?.position = bsv.center
                self.view.addSubview(bullet!.spriteView!)
                model.bulletFired = true
                soundFX.shootSound()
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    
}

