//
//  MPCHandler.swift
//  Controller
//
//  Created by Huang Ying-Kai on 1/28/16.
//  Copyright © 2016 Kai. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class MPCHandler: NSObject, MCSessionDelegate{
    
    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    
    func setupPeerWithDisplayName(displayName: String){
    
        peerID = MCPeerID(displayName: displayName)
        
    }
    func setupSession(){
        
        
        session = MCSession(peer: peerID)
        session.delegate = self
        
    }
    func setupBrowser(){

        browser = MCBrowserViewController(serviceType: "game", session: session)
        
    }
    
    func advertiseSelf(advertise: Bool){
        if advertise{
            advertiser = MCAdvertiserAssistant(serviceType: "game", discoveryInfo: nil, session: session)
            advertiser!.start()
        }else{
            advertiser?.stop()
            advertiser = nil
        }
        
    }
    
    // MCSeesion delegate implimentation function
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        let userInfo = ["peerID": peerID, "state": state.rawValue]
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("MPC_Change_State", object: nil, userInfo: userInfo)
        }
    }
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
        let dictionary: [String: AnyObject] = ["data": data, "fromPeer": peerID]
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("MPC_Receive_Data", object: nil, userInfo: dictionary)
        }
    }
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {}
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {}
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    
}