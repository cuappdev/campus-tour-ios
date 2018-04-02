//
//  LinearAlgebra.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 4/2/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import Foundation
import SceneKit

extension float4x4 {
    func extractTranslation(homogenize: Bool = true) -> float3 {
        var v = self.columns.3
        if homogenize {
            v = v.homogenize()
        }
        return v.downgrade()
    }
    
    static func identity() -> float4x4 {
        return float4x4(
            diagonal: float4(
                x: 1.0,
                y: 1.0,
                z: 1.0,
                w: 1.0
        ))
    }
    
    static func scale(_ v: Float) -> float4x4 {
        return scale(float4(x: v, y: v, z: v, w: 1.0))
    }
    
    static func scale(_ v: float4) -> float4x4 {
        return float4x4(diagonal: v)
    }
}

extension float4 {
    func homogenize() -> float4 {
        return self / self.w
    }
    
    func downgrade() -> float3 {
        return float3(x, y, z)
    }
}

extension float3 {
    func cross(_ other: float3) -> float3 {
        let matrix_i = simd_float2x2(
            float2(self.y, other.y),
            float2(self.z, other.z))
        
        let matrix_j = simd_float2x2(
            float2(self.x, other.x),
            float2(self.z, other.z))
        
        let matrix_k = simd_float2x2(
            float2(self.x, other.x),
            float2(self.y, other.y))
        
        return float3(
            x: simd_determinant(matrix_i),
            y: -simd_determinant(matrix_j),
            z: simd_determinant(matrix_k))
    }
    
    func norm() -> Float {
        return ((self.x * self.x) +
            (self.y * self.y) +
            (self.z * self.z)).squareRoot()
    }
    
    func normalize() -> float3 {
        return self / norm()
    }
}

extension float3x3 {
    func upgrade(homogeneous: Float) -> float4x4 {
        return float4x4(
            float4(x: self.columns.0.x, y: self.columns.0.y, z: self.columns.0.z, w: 0),
            float4(x: self.columns.1.x, y: self.columns.1.y, z: self.columns.1.z, w: 0),
            float4(x: self.columns.2.x, y: self.columns.2.y, z: self.columns.2.z, w: 0),
            float4(x: 0, y: 0, z: 0, w: homogeneous)
        )
    }
}

func matrix4LookAtZ(direction: float3) -> float4x4 {
    let newZ = direction.normalize()
    let newX = float3(0.0, 1.0, 0.0).cross(newZ)
    let newY = newZ.cross(newX)
    
    return float3x3(newX, newY, newZ).upgrade(homogeneous: 1)
}
