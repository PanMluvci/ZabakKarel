//
//  GameOverScene.swift
//  ZabakKarel
//
//  Created by Josef Antoni on 05.01.15.
//  Copyright (c) 2015 Josef Antoni. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, text: String, skore: Int) {
      
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        var message = text
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        let label1 = SKLabelNode(fontNamed: "Chalkduster")
        let label2 = SKLabelNode(fontNamed: "Chalkduster")

        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/1.4)
        self.backgroundColor = UIColor(red: 151/255, green: 186/255, blue: 255/255, alpha: 1.0)
        label.fontColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        addChild(label)
        
        label1.text = "Bublinky: " + String(skore)
        label1.fontSize = 40
        label1.fontColor = SKColor.blackColor()
        label1.position = CGPoint(x: size.width/2, y: size.height/2)
        label1.fontColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        addChild(label1)
        
        label2.text = "Tapni pro nový start hry."
        label2.fontSize = 20
        label2.fontColor = SKColor.blackColor()
        label2.position = CGPoint(x: size.width/2, y: size.height/3)
        label2.fontColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        addChild(label2)
        
        
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
        required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
