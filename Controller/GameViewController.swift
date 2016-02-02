//
//  GameViewController.swift
//  Controller
//
//  Created by Huang Ying-Kai on 1/28/16.
//  Copyright (c) 2016 Kai. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity


class GameViewController: UIViewController,MCBrowserViewControllerDelegate {
    
    var appDelegate: AppDelegate!
    var connected = false
    var GMScene: GameScene!
    var ConScene: ConnectScene!
    var beginScene: BeginScene!

    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.mpcHandler.setupPeerWithDisplayName(UIDevice.currentDevice().name)
        appDelegate.mpcHandler.setupSession()
        //appDelegate.mpcHandler.advertiseSelf(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showState:", name: "MPC_Change_State", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveData:", name: "MPC_Receive_Data", object: nil)
        
        beginScene = BeginScene(size: view.bounds.size)
        
        GMScene = GameScene(size: view.bounds.size)
        GMScene.viewController = self
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        //skView.ignoresSiblingOrder = true
        GMScene.scaleMode = .ResizeFill
        skView.presentScene(GMScene)

    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func showState(notification: NSNotification){
        
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.objectForKey("state") as! Int
        
        if state == MCSessionState.Connected.rawValue{
            print("connected")
            connected = true
            if connected {
                self.GMScene.light.texture = SKTexture(imageNamed: "greenlight.png")
            }
        }else if state == MCSessionState.Connecting.rawValue{
            print("connecting")
            connected = false
        }else{
            if self.appDelegate.mpcHandler.session.connectedPeers.count < 1{
                print("not connected")
                connected = false
                self.GMScene.light.texture = SKTexture(imageNamed: "redlight.png")
            }

        }
    }

    
    func invite(){
        
        if appDelegate.mpcHandler.session != nil{
            
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self
            self.presentViewController(appDelegate.mpcHandler.browser, animated: true, completion: nil)
            
        }
        
    }
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendMessage(info: String, obj: AnyObject?){

        var dictionary: [String: AnyObject]

        if info == "rec" {
            dictionary = ["type":"button", "info": "rec"]
        }else if info == "tri"{
            dictionary = ["type":"button", "info": "tri"]
        }else if info == "cross"{
            dictionary = ["type":"button", "info": "cross"]
        }else if info == "start"{
            dictionary = ["type":"button", "info": "start"]
        }else{                                               //joystick
            dictionary = ["type":"joystick", "info": obj!]
        }
        
        let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
        do{
            try! appDelegate.mpcHandler.session.sendData(dataToSend, toPeers: appDelegate.mpcHandler.session.connectedPeers, withMode:MCSessionSendDataMode.Reliable)
        }
        
    }
    

    
    
    func receiveData(notification: NSNotification) {
        
        
        
    }



    
}
