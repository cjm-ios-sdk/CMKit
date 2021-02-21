//
//  CMCGAffineTransform.h
//  CMMath
//
//  Created by chenjm on 2013/10/10.
//  Copyright (c) 2013 chenjm. All rights reserved.

#ifndef CMCGAffineTransform_h
#define CMCGAffineTransform_h

#import <CoreGraphics/CoreGraphics.h>
#include <stdio.h>

/**
 * @brief 获取弧度，范围 [0, 2pi]
 * @param t transform 仿射矩阵
 */
extern CGFloat CMGetRadianFromTransform(CGAffineTransform t);

/**
 * @brief 获取x方向的缩放比例
 * @param t transform 仿射矩阵
 */
extern CGFloat CMGetScaleXFromTransform(CGAffineTransform t);

/**
 * @brief 获取y方向的缩放比例
 * @param t transform 仿射矩阵
*/
extern CGFloat CMGetScaleYFromTransform(CGAffineTransform t);

/**
 * @brief 获取x方向的偏移值
 * @param t transform 仿射矩阵
*/
extern CGFloat CMGetTranslateXFromTransform(CGAffineTransform t);

/**
 * @brief 获取y方向的偏移值
 * @param t transform 仿射矩阵
 */
extern CGFloat CMGetTranslateYFromTransform(CGAffineTransform t);

/**
 * @brief 获取以sourceRect为中心做transform变换后的rect
 * @param t transform 仿射矩阵
 * @param sourceRect 原始的Rect
 */
extern CGRect CMGetRectByTransformAndRectCenter(CGAffineTransform t, CGRect sourceRect);


#endif /* CMCGAffineTransform_h */
