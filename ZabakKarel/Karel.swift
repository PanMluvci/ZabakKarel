//
//  Karel.swift
//  ZabakKarel
//
//  Created by Josef Antoni on 12.11.14.
//  Copyright (c) 2014 Josef Antoni. All rights reserved.
//

import Foundation
import SpriteKit

class Karel: SKSpriteNode {
    
    init(obrazekNazev: String){
    var karelTexture = SKTexture(imageNamed: obrazekNazev)
    super.init (texture: karelTexture, color: nil, size: karelTexture.size());
    self.physicsBody = SKPhysicsBody(texture: karelTexture, size: self.size)
    
    //self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)

    self.physicsBody?.allowsRotation = false
    self.physicsBody?.usesPreciseCollisionDetection = true
    }
    /**
    *   Metoda pro skok Karla, jeho animace a zvuk.
    */
    func karelUpdate(lokaceX:CGFloat,karelTurn:CGFloat){
        self.physicsBody?.velocity = CGVectorMake(0, 0)
        self.physicsBody?.applyImpulse(CGVectorMake(lokaceX/4, 20))// nastavení dálky skoku
        let atlas = SKTextureAtlas(named: "zabak.atlas")
        let anim = SKAction.animateWithTextures([
            atlas.textureNamed("zabak2"),
            atlas.textureNamed("zabak3"),
            ], timePerFrame: 0.2)
        
        self.runAction(anim)
        self.xScale = karelTurn;
        runAction(SKAction.playSoundFileNamed("smb2_jump.wav", waitForCompletion: false))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}