//
//  ConnectScene.swift
//  Controller
//
//  Created by Huang Ying-Kai on 1/28/16.
//  Copyright © 2016 Kai. All rights reserved.
//

import SpriteKit

class BeginScene: SKScene {
    
    let inviteLabel = SKLabelNode(fontNamed: "Chalkduster")
    var viewController: GameViewController?
    
    
    override init(size: CGSize) {
        
        super.init(size: size)
        backgroundColor = SKColor.whiteColor()
        
        
        inviteLabel.text = "Connect To My Mac"
        inviteLabel.fontSize = 25
        inviteLabel.fontColor = SKColor.blackColor()
        inviteLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(inviteLabel)
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor(red: 0.5, green:0.5, blue:0.5, alpha: 0.5)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.inviteLabel{
                self.viewController?.invite()
            }
        }
    }
}

