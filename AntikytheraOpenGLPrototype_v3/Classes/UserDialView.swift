//
//  UserDialView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import UIKit
import OpenGLES

class UserDialView: NSObject, ModelView, Touchable {
    var position: Vector3D
    var rotation: Double
    var radius: Double
    var color: Color3D
    
    var myView: UIView!
    var myMechanism: AntikytheraMechanism!
    
    // Touch-handling:
    var lastPosition: Vector3D
    
    let boxModel: BoxModel

    init(radius rad: Float, mechanism: AntikytheraMechanism, view: UIView) {
		position = Vector3D.zero
        lastPosition = position
        rotation = 0
		radius = Double(rad)
        color = Color3D(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		
		myView = view
		myMechanism = mechanism
		
		boxModel = BoxModel(width: rad*0.1, height: rad*0.75, length:0.5)
}

    func setOpacity(_ opac: Float) { color.alpha = opac }

    func hitTest(_ hit: Vector3D) -> Bool {
        let outerRadius = radius*1.75
        let innerRadius = radius*0.75
        let distance = hypot(Double(hit.x-position.x), Double(hit.y-position.y))
        
        if ((distance <= outerRadius)&&(distance >= innerRadius)) {
            return true
        } else {
            return false
        }
    }

    func draw() {
        let sides = 32
        
        let angleInc = 360.0/Double(sides)
        
        glPushMatrix()
        
        glTranslatef(position.x, position.y, position.z)
        glRotatef(GLfloat(rotation), 0.0, 0.0, 1.0)
        
        for i in 0 ..< sides {
            let angle = Double(i)*angleInc
            
            glPushMatrix()
            glTranslatef(GLfloat(radius*cos(DegreesToRadians(angle))), GLfloat(radius*sin(DegreesToRadians(angle))), 0.0)
            glRotatef(GLfloat(angle), 0.0, 0.0, 1.0)
            glColor4f(color.red, color.green, color.blue, color.alpha)
            boxModel.draw()
            glPopMatrix()
        }
        
        glPopMatrix()
    }

    func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        let allTouches = event?.touches(for: myView)
        let touch = allTouches?.first
        let location = touch?.location(in: myView)
        lastPosition = Vector3D(x: Float(location!.x), y: Float(myView.bounds.size.height-location!.y), z: 0.0)
    }
    
    func touchesMoved(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        let allTouches = event?.touches(for: myView)
        let touch = allTouches?.first
        let location = touch?.location(in: myView)
        let newPosition = Vector3D(x: Float(location!.x), y: Float(myView.bounds.size.height-location!.y), z: 0.0)
        
        var norm1 = position.startAndEndPoints(lastPosition)
        var norm2 = position.startAndEndPoints(newPosition)
        
        norm1.normalize()
        norm2.normalize()
        
        var angle: Double = Double(atan2f(norm2.y,norm2.x) - atan2f(norm1.y,norm1.x))
        
        if fabs(angle) >= .pi {
            if angle > 0 {
                angle -= 2.0 * .pi
            } else {
                angle += 2.0 * .pi
            }
        }
        
        angle = RadiansToDegrees(angle)
        if (angle != 0.0) {
            rotation += angle
//            NSLog("%f",angle)
            myMechanism.rotate(Float(angle))
            
            lastPosition = newPosition
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
    }

}
