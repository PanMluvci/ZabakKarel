//
//  GameStart.swift
//  ZabakKarel
//
//  Created by Josef Antoni on 26.01.15.
//  Copyright (c) 2015 Josef Antoni. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class GameStart: SKScene, SKPhysicsContactDelegate {
    
    var backgroundMusicPlayer: AVAudioPlayer!
    var groundSprite = SKSpriteNode()
    var karel:Karel? = Karel(obrazekNazev: "zabak1")
    var platform:Platform?
    var bubble:Bubbles?
    var bubbleBot:Bubbles?
    
    var moveKarel:SKAction = SKAction()
    var pipesMoveAndRemoveTop = SKAction()
    var pipesMoveAndRemoveBot = SKAction()
    var bubbleMoveAndRemoveTop = SKAction()
    var bubbleMoveAndRemoveBot = SKAction()
    var bubbleColisionRemove = SKAction()
    var refreshMovement:SKAction = SKAction()
    
    var timeForTravel:NSTimeInterval = 0
    var time:dispatch_time_t = 0
    var pocitadlo:Int = 0
    var label:SKLabelNode = SKLabelNode()
    
    var platformaKontakt = false
    var blindTouch:Int = 0
    
    /**
     *   Deklarování kolizních typů objektů.
     */
    enum ColliderType:UInt32{
        case KarelCT = 1
        case PlatformCT = 2
        case GroundCT = 3
        
        case BubbleCT = 5
        case BubbleBotCT = 6
    }
    
    /**
     * Základní metoda pro vykreslování
     */
    override init(size: CGSize) {
        
        super.init(size: size)

        self.callForWait()
        setupScene()
        pipes()
        bubbles()
        stopWatch()
        contactKarelPlatform()
        
        self.physicsWorld.contactDelegate = self

    }
    
    /**
     * Metoda pro přehrávání muziky na pozadí aplikace
     */
    func playBackgroundMusic(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(
            filename, withExtension: nil)
        if (url == nil) {
            println("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        backgroundMusicPlayer =
            AVAudioPlayer(contentsOfURL: url, error: &error)
        if backgroundMusicPlayer == nil {
            println("Could not create audio player: \(error!)")
            return
        }
        
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    
    
    /**
     * Animace plovoucích plošin objektů.
     *  @distanceToMove: Vzdálenost kam se má plošina pohybovat.
     *  @movePipesTop: Vdálenost která se má urazit za daný čas. Pro horní plošinu.
     *  @movePipesBot: Vdálenost která se má urazit za daný čas. Pro dolní plošinu.
     *  @pipesMoveAndRemoveTop: Sekvence akcí vykonána najednou pospolu. Pro horní plošinu.
     *  @pipesMoveAndRemoveBot: Sekvence akcí vykonána najednou pospolu. Pro dolní plošinu.
     */
    func pipes(){
        let distanceToMove = CGFloat(self.frame.size.width * 1.2)
        let movePipesTop = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(5))
        let removePipesTop = SKAction.removeFromParent()
        let movePipesBot = SKAction.moveByX(distanceToMove, y: 0.0, duration: NSTimeInterval(10))
        let removePipesBot = SKAction.removeFromParent()
        
        pipesMoveAndRemoveTop = SKAction.sequence([movePipesTop,removePipesTop])
        pipesMoveAndRemoveBot = SKAction.sequence([movePipesBot,removePipesBot])
        
        let spawnTop = SKAction.runBlock({() in self.spawnPlatformTop()})
        let delayTop = SKAction.waitForDuration(NSTimeInterval(5.0))
        let spawnThenDelayTop = SKAction.sequence([ spawnTop, delayTop])
        let spawnThenDelayForeverTop = SKAction.repeatActionForever(spawnThenDelayTop)
        self.runAction(spawnThenDelayForeverTop)
        
        let spawnBot = SKAction.runBlock({() in self.spawnPlatformBot()})
        let delayBot = SKAction.waitForDuration(NSTimeInterval(4.0))
        let spawnThenDelayBot = SKAction.sequence([ spawnBot, delayBot])
        let spawnThenDelayForeverBot = SKAction.repeatActionForever(spawnThenDelayBot)
        self.runAction(spawnThenDelayForeverBot)
        
    }
    /**
     * Animace bublin.
     */
    func bubbles(){
        let distanceToMove = CGFloat(self.frame.size.width * 1.2)
        
        //pro Top
        let moveBubblesTop = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(5))
        let removeBubblesTop = SKAction.removeFromParent()
        
        bubbleMoveAndRemoveTop = SKAction.sequence([moveBubblesTop,removeBubblesTop])
        
        let spawnBub = SKAction.runBlock({() in self.spawnBubblesTop()})
        let delayBubTop = SKAction.waitForDuration(NSTimeInterval(5.0))
        let spawnThenDelayBubTop = SKAction.sequence([ spawnBub, delayBubTop])
        let spawnThenDelayBubForeverTop = SKAction.repeatActionForever(spawnThenDelayBubTop)
        self.runAction(spawnThenDelayBubForeverTop)
        
        //pro Bot
        let moveBubblesBot = SKAction.moveByX(distanceToMove, y: 0.0, duration: NSTimeInterval(10))
        let removeBubblesBot = SKAction.removeFromParent()
        
        bubbleMoveAndRemoveBot = SKAction.sequence([moveBubblesBot,removeBubblesBot])
        
        let spawnBubBot = SKAction.runBlock({() in self.spawnBubblesBot()})
        let delayBubBot = SKAction.waitForDuration(NSTimeInterval(8.0))
        let spawnThenDelayBubBot = SKAction.sequence([ spawnBubBot, delayBubBot])
        let spawnThenDelayBubForeverBot = SKAction.repeatActionForever(spawnThenDelayBubBot)
        self.runAction(spawnThenDelayBubForeverBot)
        
        
    }
    
    func spawnBubblesTop(){
        bubble = Bubbles(obrazekNazev: "bubble")
        self.addChild(bubble!)
        bubble?.position = CGPointMake(self.frame.size.width * 1.1, self.frame.size.height * 0.67)
        bubble?.runAction(bubbleMoveAndRemoveTop)
        
    }
    
    func spawnBubblesBot(){
        bubbleBot = Bubbles(obrazekNazev: "bubble2")
        self.addChild(bubbleBot!)
        bubbleBot?.position = CGPointMake(self.frame.size.width + (self.frame.size.width * -1.1), self.frame.size.height * 0.47)
        bubbleBot?.runAction(bubbleMoveAndRemoveBot)
        
    }
    
    /**
    * Vytvoření nového objektu "platform", přidáním ho do scény, pozicování a vykonání
    * Akce pohybu + odebrání.
    */
    func spawnPlatformTop(){
        platform = Platform(obrazekNazev: "platform")
        self.addChild(platform!)
        platform?.position = CGPointMake(self.frame.size.width * 1.1, self.frame.size.height * 0.6) //pozicování framu
        platform?.runAction(pipesMoveAndRemoveTop)
        contactKarelPlatform()
        
    }
    
    /**
    * Vytvoření nového objektu "platform", přidáním ho do scény, pozicování a vykonání
    * Akce pohybu + odebrání.
    */
    func spawnPlatformBot(){
        platform = Platform(obrazekNazev: "platform")
        self.addChild(platform!)
        
        platform?.position = CGPointMake(self.frame.size.width + (self.frame.size.width * -1.1), self.frame.size.height * 0.4) //pozicování framu
        platform?.runAction(pipesMoveAndRemoveBot, withKey: "platformBot")
        contactKarelPlatform()
    }
    
    /**
    * Vložení do těla objektu typ čísla kolize pro karel + platform.
    *
    */
    func contactKarelPlatform(){
        karel?.physicsBody!.categoryBitMask = ColliderType.KarelCT.rawValue
        platform?.physicsBody!.categoryBitMask = ColliderType.PlatformCT.rawValue
        platform?.physicsBody!.contactTestBitMask = ColliderType.KarelCT.rawValue
        platform?.physicsBody!.collisionBitMask = ColliderType.KarelCT.rawValue
        
        groundSprite.physicsBody!.categoryBitMask = ColliderType.GroundCT.rawValue
        groundSprite.physicsBody!.contactTestBitMask = ColliderType.KarelCT.rawValue
        groundSprite.physicsBody!.collisionBitMask = ColliderType.KarelCT.rawValue
        
        bubble?.physicsBody!.categoryBitMask = ColliderType.BubbleCT.rawValue
        bubble?.physicsBody!.contactTestBitMask = ColliderType.KarelCT.rawValue
        bubble?.physicsBody!.collisionBitMask = ColliderType.KarelCT.rawValue
        
        bubbleBot?.physicsBody!.categoryBitMask = ColliderType.BubbleBotCT.rawValue
        bubbleBot?.physicsBody!.contactTestBitMask = ColliderType.KarelCT.rawValue
        bubbleBot?.physicsBody!.collisionBitMask = ColliderType.KarelCT.rawValue
    }
    
    /**
    *  Metoda která řeší kolize mezi Objekty.
    *  Vykreslování Karla a jeho animaci.
    *  Zajištění posuvu Karla spolu s plošinou, po daném směru.
    */
    func didBeginContact(contact: SKPhysicsContact) {
        karel?.removeAllActions()
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
            
        case ColliderType.KarelCT.rawValue | ColliderType.PlatformCT.rawValue:
            karel?.texture = SKTexture(imageNamed: "zabak1")
            platformaKontakt = true
            /*
            * zajištění posuvu karla spolu s plošinou, po daném směru
            */
            if(karel?.position.y > self.size.height/3){ // podminka pro zamezení pohybu na zemi
                var distanceToMove = CGFloat(self.frame.size.width)
                if(karel?.position.y > self.size.height/2){ // bude se pohybovat na plošině dole
                    distanceToMove = -distanceToMove
                    timeForTravel = 4.20
                }else{  //bude se pohybovat na plošině nahoře
                    timeForTravel = 8.40
                }
                moveKarel = SKAction.moveByX(distanceToMove, y: 0.0, duration: NSTimeInterval(timeForTravel))
                
                karel?.runAction(moveKarel, withKey: "travelingOnPlatforms")
            }
            
            //kolize pro TOP bubliny
        case ColliderType.KarelCT.rawValue | ColliderType.BubbleCT.rawValue:
            platformaKontakt = true
            bubble?.removeFromParent()
            pocitadlo = pocitadlo + 1
            label.text = String(pocitadlo)
            
            //kolize pro BOT bubliny
        case ColliderType.KarelCT.rawValue | ColliderType.BubbleBotCT.rawValue:
            platformaKontakt = true
            bubbleBot?.removeFromParent()
            pocitadlo = pocitadlo + 1
            label.text = String(pocitadlo)
            
        default:
            platformaKontakt = true
        }
    }
    
    
    /**
     *   Po konci kontaktu se Karel nebude dále pohybovat po ose X ale zůstává
     *   na místě kde přistál.
     */
    func didEndContact(contact: SKPhysicsContact) {
        karel?.removeActionForKey("travelingOnPlatforms")
        platformaKontakt = false
    }
    
    /*
     *  Zachycení dotyku. Podle pozice dotyku zavolá metodu která posune obrazec daným směrem.
    *   @blindTouch: Řeší problém kdy se hodnata BOOL nepřepla a žabák stojí na místě.
    */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            var lokaceX:CGFloat = 0;
            
            //Ověření kde se nachází Karel a podle toho ho posunout
            if(location.x >= self.frame.size.width * 0.5 && platformaKontakt == true){
                lokaceX = lokaceX + 30
                karel?.karelUpdate(lokaceX, karelTurn: 1.0)
            }
            if(location.x < self.frame.size.width * 0.5 && platformaKontakt == true){
                lokaceX = lokaceX - 30
                karel?.karelUpdate(lokaceX, karelTurn: -1.0)
            }
            if(platformaKontakt==false){
                blindTouch = blindTouch + 1
            }
        }
    }
    
    /*
     *  Kontrola Karla aby nezmizel ze scény.
     */
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //GAME OVER
        
        if(karel?.position.x < 0 || karel?.position.x > self.frame.width){
            gameOverM("zkus to znovu :-)")
        }
        if(karel?.position.x >= self.frame.width * 0.95){
            //karel?.removeAllActions()
            karel?.position.x = self.frame.width * 0.95
        }
        if(karel?.position.x <= self.frame.width * 0.05){
            //karel?.removeAllActions()
            karel?.position.x = self.frame.width * 0.05
        }
        
        if(platformaKontakt == false && blindTouch > 4){
            platformaKontakt = true
        }
        if(platformaKontakt == true){
            blindTouch = 0
        }
        
    }
    
    /**
    *   Po uběhnutí času (70 sekund) se ukončí hra. Metodou GameOverM.
    */
    func callForWait(){
        // delay na 70 sekund.
        var delay = 70 * Double(NSEC_PER_SEC)
        time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.gameOverM("Čas vypršel.")
        }
    }
    
    /**
     *  Textové pole zobrazující počet nachytaných bublin.
     */
    func stopWatch(){
        label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = String(pocitadlo)
        label.fontSize = 50
        label.fontColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)

        label.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 0.8)
        self.addChild(label)
    }
    
    /**
    *   Odebrání všech akcí a potomků. Ukončení hry.
    *   Volání předka GameOverScene
    */
    func gameOverM(textInput:String){
        self.removeAllActions()
        self.removeAllChildren()
        let loseAction = SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, text:textInput, skore: self.pocitadlo)
            self.view?.presentScene(gameOverScene, transition: reveal)
            
        }
        self.runAction(loseAction)
        
    }
    
    /**
     *   Nastavení základních chování scény.
     */
    func setupScene(){
        self.playBackgroundMusic("music.mp3")
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        var groundTexture = SKTexture(imageNamed: "ground")
        groundSprite = SKSpriteNode(texture: groundTexture)
        groundSprite.setScale(2.0) //2x zvetsim obrazek
        groundSprite.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * 0.1) //pozicování framu
        groundSprite.physicsBody = SKPhysicsBody(rectangleOfSize: groundSprite.size)
        groundSprite.physicsBody?.dynamic = false
        karel?.position = CGPointMake(self.frame.size.width * 0.5 , self.frame.size.height * 0.5)
        groundSprite.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(groundSprite)
        self.addChild(karel!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}