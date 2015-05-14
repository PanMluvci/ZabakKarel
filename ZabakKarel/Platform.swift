//
//  Platform.swift
//  ZabakKarel
//
//  Created by Josef Antoni on 18.11.14.
//  Copyright (c) 2014 Josef Antoni. All rights reserved.
//

import Foundation
import SpriteKit

class Platform: SKSpriteNode {
    
    var pipesMoveAndRemove = SKAction()

    /**
    *   Základní parametry platformy.
    */
    init(obrazekNazev: String){
        var groundTexture = SKTexture(imageNamed: obrazekNazev)
        super.init (texture: groundTexture, color: nil, size: groundTexture.size());
        self.physicsBody = SKPhysicsBody(texture: groundTexture, size: self.size)
        self.setScale(0.5)
        self.physicsBody?.dynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}