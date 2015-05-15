//
//  GameScene.swift
//  ZabakKarel
//
//  Created by Josef Antoni on 05.11.14.
//  Copyright (c) 2014 Josef Antoni. All rights reserved.
//
// 
import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {


    override func didMoveToView(view: SKView) {
        
        let menuImage = SKSpriteNode(imageNamed: "title")
        menuImage.setScale(0.65)
        menuImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(menuImage)
        backgroundColor = SKColor.whiteColor()

        self.backgroundColor = UIColor(red: 151/255, green: 186/255, blue: 255/255, alpha: 1.0)
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Tapni pro start :-)"
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/5.5)
        addChild(label)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        runAction(SKAction.sequence([
            SKAction.waitForDuration(0.5),
            SKAction.runBlock() {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = GameStart(size: self.size)
                self.view?.presentScene(scene, transition:reveal)
                scene.backgroundColor = UIColor(red: 151/255, green: 186/255, blue: 255/255, alpha: 1.0)
                
            }
            ]))
        }
}