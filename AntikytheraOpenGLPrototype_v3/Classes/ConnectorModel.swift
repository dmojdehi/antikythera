//
//  ConnectorModel.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

class ConnectorModel: GLModel3D {
    
    init(connector: Connector) {
        super.init()
		buildModelFromConnector(connector)
    }

    func buildModelFromConnector(connector: Connector) {
        let sideCount = 16
        
        let radius = connector.getRadius()
        
        let sliceAngle = Float(2.0*M_PI)/Float(sideCount)
        let halfAngle = sliceAngle/2.0
        
        vertices = [Vertex3D](count: (sideCount*4+2), repeatedValue: Vertex3D.Zero)
        elements = [GLushort](count: (sideCount*10+1), repeatedValue: 0)
        
        
        // Vertices:
        vertices[0] = Vertex3D(x: 0.0, y: 0.0, z: 1.0)
        vertices[1] = Vertex3D(x: 0.0, y: 0.0, z: -1.0)
        
        for var i=0; i<sideCount; i++ {
            let angle = Float(i)*sliceAngle
            
            vertices[i*4+2] = Vertex3D(x: radius*cos(angle-halfAngle), y: radius*sin(angle-halfAngle), z: 1.0)
            vertices[i*4+3] = Vertex3D(x: radius*cos(angle), y: radius*sin(angle), z: 1.0)
            
            vertices[i*4+4] = Vertex3D(x: radius*cos(angle-halfAngle), y: radius*sin(angle-halfAngle), z: -1.0)
            vertices[i*4+5] = Vertex3D(x: radius*cos(angle), y: radius*sin(angle), z: -1.0)
        }
        
        
        // Elements:
        for var i=0; i<sideCount; i++ {
            elements[i*10] = 0;		//1
            elements[i*10+1] = GLushort(i*4+2)	//2
            elements[i*10+2] = GLushort(i*4+3)	//3
            elements[i*10+3] = GLushort(i*4+4)	//6
            elements[i*10+4] = GLushort(i*4+5)	//7
            elements[i*10+5] = 1		//5
            elements[i*10+6] = GLushort(i*4+5)	//7
            elements[i*10+8] = GLushort(i*4+3)	//3
            
            if (i<(sideCount-1)) {
                elements[i*10+7] = GLushort((i+1)*4+4)	//8
                elements[i*10+9] = GLushort((i+1)*4+2)	//4
            } else {
                elements[i*10+7] = 4	//8
                elements[i*10+9] = 2	//4
                elements[i*10+10] = 0	//1
            }
        }
    }

}
