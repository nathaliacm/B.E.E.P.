//
//  MapScene.swift
//  B.E.E.P.
//
//  Created by Nathália Cardoso on 09/06/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import SpriteKit
import GameplayKit

class MapScene:SKScene {
    
    var entityManager:EntityManager!
    var filamentScale:CGFloat = -1
    var posicao:Int = 0
    var locationAnterior:CGPoint = CGPoint(x: 0, y: 0)
    
    enum Direction {
        case backward
        case forward
    }
    
    override func didMove(to view: SKView) {
        entityManager = EntityManager(scene: self)
        drawBackground()
        drawnHintButton()
        drawnConfigButton()
        
        let tilesetReference1 = CGPoint(x: frame.midX-280, y: frame.midY+90+40+40)
        let filamentReference1 = CGPoint(x: frame.midX-69, y: frame.midY+16)
        
        let tilesetReference2 = CGPoint(x: frame.midX+101.5, y: frame.midY-28)
        let filamentReference2 = CGPoint(x: frame.midX+278, y: frame.midY+16)
        
        let tilesetReference3 = CGPoint(x: frame.midX+393, y: frame.midY+155)
        let filamentReference3 = CGPoint(x: frame.midX+602, y: frame.midY+2)
        
        
        let tilesetReference4 = CGPoint(x: frame.midX+741, y: frame.midY-59)
        let filamentReference4 = CGPoint(x: frame.midX+914, y: frame.midY-14)
        
        let tilesetReference5 = CGPoint(x: frame.midX+1028, y: frame.midY+124)
        
        
        drawnMaps(height: 3, width: 5, tilesetReference: tilesetReference1, status: "available", showRobot:true)
        
        drawnFilament(filamentReference: filamentReference1, status: "unavailable")
        
        drawnMaps(height: 5, width: 5, tilesetReference: tilesetReference2, status: "unavailable", showRobot:false)
        drawnFilament(filamentReference: filamentReference2, status: "unavailable")
        
        drawnMaps(height: 3, width: 5, tilesetReference: tilesetReference3, status: "unavailable", showRobot:false)
        drawnFilament(filamentReference: filamentReference3, status: "unavailable")
        
        drawnMaps(height: 3, width: 5, tilesetReference: tilesetReference4, status: "unavailable", showRobot:false)
        drawnFilament(filamentReference: filamentReference4, status: "unavailable")
        
        drawnMaps(height: 3, width: 5, tilesetReference: tilesetReference5, status: "unavailable", showRobot:false)

    }
    
    func drawBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: size.width, height: size.height)
        addChild(background)
    }
    
    func drawnMaps(height:Int, width:Int, tilesetReference: CGPoint, status:String, showRobot:Bool) {
        var lightFloorPosition = CGPoint(x: 0, y: 0)
        var stageUnavailablePosition = CGPoint(x: 0, y: 0)
        for i in 1...width {
            for j in 1...height {
                // desenha o tileset
                let tileset = Tileset(status: status)
                if let spriteComponent = tileset.component(ofType: SpriteComponent.self) {
                    let x = (CGFloat(32*(i - 1)) - CGFloat(32*(j - 1))) + tilesetReference.x
                    let y = (CGFloat(-16*(i - 1)) - CGFloat(16*(j - 1))) + tilesetReference.y
                    spriteComponent.node.name = "stage-\(status)"
                    spriteComponent.node.position = CGPoint(x: x, y: y)
                    spriteComponent.node.zPosition = CGFloat(i + j)
                    if (i-1) == (width-1)/2 && (j-1) == (height-1)/2 {
                        if showRobot {
                            lightFloorPosition = CGPoint(x: x, y: y)
                            drawnLightFloor(position: lightFloorPosition)
                            drawnRobot(position: CGPoint(x: lightFloorPosition.x, y: lightFloorPosition.y+31))
                        } else {
                            stageUnavailablePosition = CGPoint(x: x, y: y+21)
                        }
                        
                    }
                }
            entityManager.add(tileset)
            }
        }
        
        if status == "unavailable" {
            drawnStageUnavailable(position: stageUnavailablePosition)
        }

    }
    func drawnLightFloor(position:CGPoint){
        let lightFloor = LightFloor()
        if let spriteComponent = lightFloor.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
            spriteComponent.node.alpha = 0.7
            spriteComponent.node.zPosition = 100
            spriteComponent.node.name = "stage-available"
        }
        entityManager.add(lightFloor)
    }
    
    func drawnRobot(position:CGPoint) {
        let robot = Robot()
        if let spriteComponent = robot.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
            spriteComponent.node.zPosition = 101
            spriteComponent.node.name = "stage-available"
        }
        entityManager.add(robot)
    }
    
    func drawnStageUnavailable(position:CGPoint) {
        let stageUnavailable = StageUnavailable()
        if let spriteComponent = stageUnavailable.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = position
            spriteComponent.node.zPosition = 100
            spriteComponent.node.name = "stage-unavailable"
        }
        entityManager.add(stageUnavailable)
    }
    
    func drawnFilament(filamentReference: CGPoint, status:String) {
        let filament = Filament(status: status)
        if let spriteComponent = filament.component(ofType: SpriteComponent.self) {
            spriteComponent.node.name = "filament-\(status)"
            if status == "unavailable" {
                spriteComponent.node.alpha = 0.35
            }
            filamentScale *= -1
            spriteComponent.node.xScale = filamentScale
            spriteComponent.node.position = filamentReference
            spriteComponent.node.zPosition = 100
        }
        entityManager.add(filament)
    }
    
    func moveMap(direction: Direction) {
            self.enumerateChildNodes(withName: "stage-available", using: ({
                (node,error) in
                if direction == Direction.backward {
                    if self.posicao > 0 {
                        node.position.x += 5
                        self.posicao -= 1
                    }
                    
                } else {
                    if self.posicao < 15160 {
                        node.position.x -= 5
                        self.posicao += 1
                        
                    }
            
                }
            }))
        
            self.enumerateChildNodes(withName: "filament-available", using: ({
                (node,error) in
                if direction == Direction.backward {
                    if self.posicao > 0 {
                        node.position.x += 5
                        self.posicao -= 1
                    }
                    
                } else {
                    if self.posicao < 15160 {
                        node.position.x -= 5
                        self.posicao += 1
                        
                    }
            
                }
            }))
        
            self.enumerateChildNodes(withName: "stage-unavailable", using: ({
                (node,error) in
                if direction == Direction.backward {
                    if self.posicao > 0 {
                        node.position.x += 5
                        self.posicao -= 1
                    }
                    
                } else {
                    if self.posicao < 15160 {
                        node.position.x -= 5
                        self.posicao += 1
                        
                    }
            
                }
            }))
        
            self.enumerateChildNodes(withName: "filament-unavailable", using: ({
                (node,error) in
                if direction == Direction.backward {
                    if self.posicao > 0 {
                        node.position.x += 5
                        self.posicao -= 1
                    }
                    
                } else {
                    if self.posicao < 15160 {
                        node.position.x -= 5
                        self.posicao += 1
                        
                    }
            
                }
            }))
            
        }
    func drawnHintButton() {
        let hintButton = SKSpriteNode(imageNamed: "hint-button")
    
        hintButton.name = "hint-button"
        hintButton.position = CGPoint(x: frame.maxX-100, y: frame.maxY-50)
        hintButton.zPosition = 2
        addChild(hintButton)
    }
    func drawnConfigButton() {
        let configButton = SKSpriteNode(imageNamed: "config-button")
    
        configButton.name = "config-button"
        configButton.position = CGPoint(x: frame.maxX-150, y: frame.maxY-50)
        configButton.zPosition = 2
        addChild(configButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            print(location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if locationAnterior.x < location.x {
                moveMap(direction: Direction.backward)
            } else {
                moveMap(direction: Direction.forward)
            }
            locationAnterior = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            if nodes[0].name == "stage-available" {
                let gameScene = GameScene(size: view!.bounds.size)
                view!.presentScene(gameScene)
            }

        }
        
    }
    
}
