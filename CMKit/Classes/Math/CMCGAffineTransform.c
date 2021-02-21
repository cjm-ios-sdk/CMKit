//
//  CMCGAffineTransform.c
//  CMMath
//
//  Created by chenjm on 2013/10/10.
//  Copyright (c) 2013 chenjm. All rights reserved.

#include "CMCGAffineTransform.h"
#import <math.h>

/*
 
 错误：
 
 平移：
      | 1  0  0 |
 t1 = | 0  1  0 |
      | dx dy 1 |
 
 缩放：
      | sx 0  0|
 t2 = | 0  sy 0|
      | 0  0  1|
 
 旋转：
      |  cos(angle)  sin(angle)  0 |
 t3 = | -sin(angle)  cos(angle)  0 |
      |  0           0           1 |
 
 
 平移、缩放、旋转：
                    
 t = t1 * t2 * t3
 
     |  sx * cos(angle)                              sx * sin(angle)                              0 |
   = | -sy * sin(angle)                              sy * cos(angle)                              0 |
     |  sx * dx * cos(angle) - sy * dy * sin(angle)  sx * dx * sin(angle) + sy * dy * cos(angle)  1 |
 
 因为，
     | a  b  0 |
 t = | c  d  0 |
     | tx ty 1 |
 
 所以，
 a = sx * cos(angle)
 b = sx * sin(angle)
 c = -sy * sin(angle)
 d = sy * cos(angle)
 tx = sx * dx * cos(angle) - sy * dy * sin(angle)
 ty = sx * dx * sin(angle) + sy * dy * cos(angle)
 
 */

/*
 
 正确：
 
 缩放：
      | sx 0  0|
 t1 = | 0  sy 0|
      | 0  0  1|
 
 
 旋转：
      |  cos(angle)  sin(angle)  0 |
 t2 = | -sin(angle)  cos(angle)  0 |
      |  0           0           1 |

 
 平移：
      | 1  0  0 |
 t3 = | 0  1  0 |
      | dx dy 1 |
 

 缩放、旋转、平移：
 
 t = t1 * t2 * t3
 
   |  sx * cos(angle)    sx * sin(angle)     0 |
 = | -sy * sin(angle)    sy * cos(angle)     0 |
   |  dx                 dy                  1 |
 
 因为，
     | a  b  0 |
 t = | c  d  0 |
     | tx ty 1 |
 
 所以，
 a = sx * cos(angle)
 b = sx * sin(angle)
 c = -sy * sin(angle)
 d = sy * cos(angle)
 tx = dx
 ty = dy
 
 */


/**
 * @brief 获取弧度，范围 [0, 2pi]
 * @param t transform 仿射矩阵
 */
CGFloat CMGetRadianFromTransform(CGAffineTransform t) {
    double sx = CMGetScaleXFromTransform(t);
    double cos_radian = t.a / sx;
    double sin_radian = t.b / sx;
    double radian = acos(cos_radian);   // [0, PI];
    
    if (sin_radian > 0) {
        radian = radian;
    } else if (sin_radian < 0) {
        radian = 2 * M_PI - radian;
    } else  {
        if (cos_radian > 0) {
            radian = radian;
        } else {
            radian = 2* M_PI - radian;
        }
    }
    return radian;
}

/**
 * @brief 获取x方向的缩放比例
 * @param t transform 仿射矩阵
 */
CGFloat CMGetScaleXFromTransform(CGAffineTransform t) {
    return sqrt(pow(t.a, 2)  + pow(t.b, 2));
}

/**
 * @brief 获取y方向的缩放比例
 * @param t transform 仿射矩阵
*/
CGFloat CMGetScaleYFromTransform(CGAffineTransform t) {
    return sqrt(pow(t.c, 2) + pow(t.d, 2));
}


/**
 * @brief 获取x方向的偏移值
 * @param t transform 仿射矩阵
*/
CGFloat CMGetTranslateXFromTransform(CGAffineTransform t) {
    return t.tx;
}

/**
 * @brief 获取y方向的偏移值
 * @param t transform 仿射矩阵
 */
CGFloat CMGetTranslateYFromTransform(CGAffineTransform t) {
    return t.ty;
}

/*
 P(x, y) -> P'(x', y')
 
 x' = a * x + c * y + tx
 y' = b * x + d * y + ty
 
 
 S(w, h) -> S'(w', h')
 
 w' = a * w + c * h'
 h' = b * w + d * h'
 */


//获取变换后的point: CGPointApplyAffineTransform(CGPoint point, CGAffineTransform t)
//获取变换后的size: CGSizeApplyAffineTransform(CGSize size, CGAffineTransform t)
//获取变换后的rect: CGRectApplyAffineTransform(CGRect rect, CGAffineTransform t)


/**
 * @brief 获取以sourceRect为中心做transform变换后的rect
 * @param t transform 仿射矩阵
 * @param sourceRect 原始的Rect
 */
CGRect CMGetRectByTransformAndRectCenter(CGAffineTransform t, CGRect sourceRect) {
    float cx = sourceRect.origin.x + sourceRect.size.width / 2;
    float cy = sourceRect.origin.y + sourceRect.size.height / 2;
    
    //将rect的中心设为原点
    CGPoint center = CGPointMake(cx, cy);
    sourceRect.origin.x = sourceRect.origin.x - center.x;
    sourceRect.origin.y = sourceRect.origin.y - center.y;
    
    //恢恢复rect的中心为原来的位置
    CGRect rect_0 = CGRectApplyAffineTransform(sourceRect, t);
    rect_0.origin.x = rect_0.origin.x + center.x;
    rect_0.origin.y = rect_0.origin.y + center.y;
    
    return rect_0;
}
