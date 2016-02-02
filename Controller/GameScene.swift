//
//  GameScene.swift
//  Controller
//
//  Created by Huang Ying-Kai on 1/28/16.
//  Copyright (c) 2016 Kai. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var viewController: GameViewController?
    var cross = SKSpriteNode(imageNamed: "cross.png")
    var rectangle = SKSpriteNode(imageNamed: "rec.png")
    var base = SKSpriteNode(imageNamed: "joybase.png")
    var stick = SKSpriteNode(imageNamed: "joystick.png")
    var start = SKSpriteNode(imageNamed: "start.png")
    var light = SKSpriteNode(imageNamed: "redlight.png")
    var stickActive = false
    var timer: NSTimer?
    var press = false
    var moveVect: CGVector = CGVector(dx: 0.0, dy: 0.0)
    var background = SKSpriteNode(imageNamed: "background.png")

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor.whiteColor()

        background.position = CGPointMake(size.width*0.5, size.height * 0.5)
        background.zPosition = -1
        cross.position = CGPointMake(size.width * 0.2, size.height * 0.15)
        rectangle.position = CGPointMake(size.width * 0.8, size.height * 0.15)
        base.position = CGPointMake(size.width * 0.5, size.height * 0.6)
        stick.position = CGPointMake(size.width * 0.5, size.height * 0.6)
        stick.zPosition = 2
        start.position = CGPointMake(size.width * 0.5, size.height * 0.3)
        light.position = CGPointMake(size.width * 0.5, size.height * 0.85)
        
        
        self.addChild(background)
        self.addChild(cross)
        self.addChild(rectangle)
        self.addChild(base)
        self.addChild(stick)
        self.addChild(start)
        self.addChild(light)
        
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        press = true
        for touch in touches {
            let location = touch.locationInNode(self)
            if CGRectContainsPoint(stick.frame, location){
                stickActive = true
            }else {
                stickActive = false
            }
            if CGRectContainsPoint(start.frame, location){
                timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "connect", userInfo: nil, repeats: false)
            }
            if CGRectContainsPoint(cross.frame, location){
                if self.viewController?.connected == true{
                    self.viewController?.sendMessage("cross", obj: nil)
                }
            }
            if CGRectContainsPoint(rectangle.frame, location){
                if self.viewController?.connected == true{
                    self.viewController?.sendMessage("rec", obj: nil)
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if !CGRectContainsPoint(start.frame, location) && timer != nil{
                timer?.invalidate()
            }

            if stickActive{ // for joystick
                
                let v = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
                let angle = atan2(v.dy, v.dx)
                
                // let deg = angle * CGFloat( 180 / M_PI )
                let length: CGFloat = base.frame.size.height / 10
                
                let xdis:CGFloat = sin(angle - 1.57079633) * length
                let ydis:CGFloat = cos(angle - 1.57079633) * length
                
                let area = CGRect(x: base.frame.origin.x, y: base.frame.origin.y, width: base.frame.width/10, height: base.frame.height/10)
                
                if(CGRectContainsPoint(area, location)){
                    stick.position = location
                    
                }else {
                    stick.position = CGPointMake(base.position.x - xdis, base.position.y + ydis)
                }
                // adjust vector
                moveVect = v
                let threshhold = CGFloat(120)
                if moveVect.dx > threshhold{
                    moveVect.dx = threshhold
                }else if moveVect.dx < -threshhold{
                    moveVect.dx = -threshhold
                }
                if moveVect.dy > threshhold{
                    moveVect.dy = threshhold
                }else if moveVect.dy < -threshhold{
                    moveVect.dy = -threshhold
                }
                print(moveVect)
                
                let vectDic: [String: Float] = ["x": Float(moveVect.dx), "y": Float(moveVect.dy)]
                
                if self.viewController?.connected == true{
            //        self.viewController?.sendMessage("joystick", obj: vectDic)
                }

            }
        }

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        press = false
        let move: SKAction = SKAction.moveTo(base.position, duration: 0.2)
        move.timingMode = .EaseOut
        stick.runAction(move)
        if timer != nil{
            timer?.invalidate()
        }
    }
    func connect(){
        self.viewController?.invite()
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        if  base.position != stick.position && self.viewController?.connected == true{
            
            print("I'm pressing")
            let vectDic: [String: Float] = ["x": Float(moveVect.dx), "y": Float(moveVect.dy)]
            
            self.viewController?.sendMessage("joystick", obj: vectDic)
        }
        
        
        /* Called before each frame is rendered */
    }
}
