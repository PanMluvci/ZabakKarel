//
//  Bubbles.swift
//  ZabakKarel
//
//  Created by Josef Antoni on 25.01.15.
//  Copyright (c) 2015 Josef Antoni. All rights reserved.
//

import Foundation
import SpriteKit

class Bubbles: SKSpriteNode {
    
    /**
    *   Základní nastavení bubliny.
    */
    init(obrazekNazev: String){
        var bubbleTexture = SKTexture(imageNamed: obrazekNazev)
        super.init (texture: bubbleTexture, color: nil, size: bubbleTexture.size());
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.setScale(0.4)
        self.physicsBody?.dynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}