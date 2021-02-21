//
//  CMGeometry.h
//  CMMath
//
//  Created by jiemin on 2014/04/29.
//  Copyright (c) 2014 chenjm. All rights reserved.

#ifndef CMGeometry_h
#define CMGeometry_h

#include <stdio.h>
#import <CoreGraphics/CoreGraphics.h>

// 是否为CGPointZero
extern bool CMIsPointZero(CGPoint p);

// 是否为CGSizeZero
extern bool CMIsSizeZero(CGSize s);

// 是否为CGRectZero
extern bool CMIsRectZero(CGRect r);

//角度转化弧度
extern CGFloat CMGetRandian(CGFloat angle);

//弧度转化角度
extern CGFloat CMGetAngle(CGFloat radian);

// 线段与rect的交点
extern CGPoint CMGetIntersection(CGPoint point0, CGPoint point1, CGRect rect, bool *flag);

// 两个线段的交点
extern CGPoint CMGetLineIntersection(CGPoint point1, CGPoint point2, CGPoint point3, CGPoint point4, bool *flag);

// 两个点的长度
extern CGFloat CMGetLength(CGPoint point0, CGPoint point1);

// 弧度，0 ～ 2pi
extern CGFloat CMGetRadian(CGPoint origin, CGPoint point0, CGPoint point1);

// 弧度，0 ~ 2pi
extern CGFloat CMGetLineRadian(CGPoint point0, CGPoint point1);

// 沿着startPoint -> endPoint 方向上距离len的点
extern CGPoint CMGetOutPoint(CGPoint startPoint, CGPoint endPoint, CGFloat len, bool *flag);

// 点point是否在rect上
extern bool CMIsPointInRect(CGPoint point, CGRect rect);

//一个点在一条直线上的投影坐标
extern CGPoint CMGetProjectionCoordinateInLine(CGPoint sourcePoint, CGPoint linePoint, CGFloat k);
extern CGPoint CMGetProjectionCoordinateInLine2(CGPoint sourcePoint, CGPoint linePoint0, CGPoint linePoint1);

//获取直线上的某个点y坐标
extern CGFloat CMGetPointXWithPointYAndLine(CGFloat pointY, CGPoint linePoint0, CGPoint linePoint1);

//获取直线上的某个点x坐标
extern CGFloat CMGetPointYWithPointXAndLine(CGFloat pointX, CGPoint linePoint0, CGPoint linePoint1);



#endif /* CMGeometry_h */
