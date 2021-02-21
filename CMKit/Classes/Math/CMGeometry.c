//
//  CMGeometry.c
//  CMMath
//
//  Created by jiemin on 2014/04/29.
//  Copyright (c) 2014 chenjm. All rights reserved.

#include "CMGeometry.h"
#import <math.h>

// 是否为CGPointZero
bool CMIsPointZero(CGPoint p) {
    return fabs(p.x) < (double)__FLT_EPSILON__ && fabs(p.y) < (double)__FLT_EPSILON__;
}

// 是否为CGSizeZero
bool CMIsSizeZero(CGSize s) {
    return fabs(s.width) < (double)__FLT_EPSILON__ && fabs(s.height) < (double)__FLT_EPSILON__;
}

// 是否为CGRectZero
bool CMIsRectZero(CGRect r) {
    return CMIsPointZero(r.origin) && CMIsSizeZero(r.size);
}

//角度转化弧度
CGFloat CMGetRandian(CGFloat angle) {
    return (angle * M_PI / 180.0);
}
//弧度转化角度
CGFloat CMGetAngle(CGFloat radian) {
    return (radian * 180.0 / M_PI);
}

// 线段与rect的交点 (如果有多个交点只回返第一个点)
CGPoint CMGetIntersection(CGPoint l1, CGPoint l2, CGRect rect, bool *flag) {    
    CGPoint p1 = {CGRectGetMinX(rect), CGRectGetMinY(rect)};
    CGPoint p2 = {CGRectGetMaxX(rect), CGRectGetMinY(rect)};
    CGPoint p3 = {CGRectGetMaxX(rect), CGRectGetMaxY(rect)};
    CGPoint p4 = {CGRectGetMinX(rect), CGRectGetMaxY(rect)};
    CGPoint p[5] = {p1, p2, p3, p4, p1};

    CGPoint p0 = CGPointZero;
    *flag = false;
    
    for (int i = 0; i < 4; i++) {
        p0 = CMGetLineIntersection(l1, l2, p[i], p[i + 1], flag);
        
        if (*flag) {
            break;
        }
    }
    
    return p0;
}

// 交叉乘积 (P1-P0) x (P2-P0)
CGFloat CMXmult(CGPoint p1, CGPoint p2, CGPoint p0) {
    return (p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y);
}

bool CMIsOnLine(CGPoint p, CGPoint l1, CGPoint l2) {
    bool flag1 = CMXmult(p, l1, l2) < 0.01;            //平行
    bool flag2 = (l1.x - p.x) * (l2.x - p.x) < 0.01; //l的x方向之间
    bool flag3 = (l1.y - p.y) * (l2.y - p.y) < 0.01; //l的y方向之间
    
    return flag1 && flag2 && flag3;
}

// 两个线段的交点
CGPoint CMGetLineIntersection(CGPoint a1, CGPoint a2, CGPoint b1, CGPoint b2, bool *flag) {
    CGPoint p = CGPointZero;
    CGVector v1 = CGVectorMake(a1.x - a2.x, a1.y - a2.y);
    CGVector v2 = CGVectorMake(b1.x - b2.x, b1.y - b2.y);
    
    if (fabs(v1.dx * v2.dy - v1.dy * v2.dx) < __FLT_EPSILON__) {  // 平行
        *flag = false;
    } else if (CMIsPointZero(CGPointMake(a1.x - a2.x, a1.y - a2.y))) { // a线段长度为0，
        // 在b线段上
        if (CMIsOnLine(a1, b1, b2)) {
            *flag = true;
            p = a1;
        } else {
           *flag = false;
        }
    } else if (CMIsPointZero(CGPointMake(a1.x - a2.x, a1.y - a2.y))) { // b线段长度为0
        // 在b线段上
        if (CMIsOnLine(b1, a1, a2))
        {
            *flag = true;
            p = b1;
        }
        else
        {
            *flag = false;
        }
    } else if (a2.x - a1.x == 0) { // a线段垂直
        CGFloat kb = (b2.y - b1.y) / (b2.x - b1.x);
        CGFloat x = a1.x;
        CGFloat y = kb * (x - b1.x) + b1.y;
        if (CMIsOnLine(CGPointMake(x, y), a1, a2) && CMIsOnLine(CGPointMake(x, y), b1, b2)) {
            *flag = true;
            p = CGPointMake(x, y);
        } else {
            *flag = false;
        }
    } else if (b2.x - b1.x == 0) { // b线段垂直
        CGFloat ka = (a2.y - a1.y) / (a2.x - a1.x);
        CGFloat x = b1.x;
        CGFloat y = ka * (x - a1.x) + a1.y;
        if (CMIsOnLine(CGPointMake(x, y), a1, a2) && CMIsOnLine(CGPointMake(x, y), b1, b2)) {
            *flag = true;
            p = CGPointMake(x, y);
        } else {
            *flag = false;
        }
    } else {
        *flag = true;
        CGFloat ka = (a2.y - a1.y) / (a2.x - a1.x);//a1(100,100) a2{120,220} b1(0,200) b2(200, 200)
        CGFloat kb = (b2.y - b1.y) / (b2.x - b1.x);
        CGFloat x = (ka * a1.x - kb * b1.x + b1.y - a1.y) / (ka - kb);
        CGFloat y = ka * (x - a1.x) + a1.y;
                
        if (CMIsOnLine(CGPointMake(x, y), a1, a2) && CMIsOnLine(CGPointMake(x, y), b1, b2)) {
            *flag = true;
            p = CGPointMake(x, y);
        } else {
            *flag = false;
        }
    }
    
    return p;
}

// 两个点的长度
CGFloat CMGetLength(CGPoint point0, CGPoint point1) {
    return sqrtf(pow(point0.x - point1.x, 2) + pow(point0.y - point1.y, 2));
}

// 弧度，0 ～ 2pi
CGFloat CMGetRadian(CGPoint origin, CGPoint point0, CGPoint point1) {
    CGFloat a = sqrt(pow(point0.x - point1.x, 2) + pow(point0.y - point1.y, 2));
    CGFloat b = sqrt(pow(origin.x - point0.x, 2) + pow(origin.y - point0.y, 2));
    CGFloat c = sqrt(pow(origin.x - point1.x, 2) + pow(origin.y - point1.y, 2));
    
    CGFloat cosA = 0.0;
    if (b != 0 && c != 0) {
        cosA = (pow(b, 2) + pow(c, 2) - pow(a, 2)) / 2 * b * c;
    }
    
    return acosf(cosA);
}

// 线弧度, 0 ~ 2pi
CGFloat CMGetLineRadian(CGPoint point0, CGPoint point1) {
    CGFloat dy = point1.y - point0.y;
    CGFloat dx = point1.x - point0.x;
    
    CGFloat A = atan2f(dy, dx);
    if (dy < 0 && dx < 0) {
        A = M_PI + A;
    }
    if (dx < 0 && dy > 0) {
        A = M_PI + A;
    }
    if (dy == 0 && dx < 0) {
        A = M_PI + A;
    }
    
    if (A < 0) {
        A = A + 2 * M_PI;
    }
    
    return A;
}

// 沿着startPoint -> endPoint 方向上距离len的点
CGPoint CMGetOutPoint(CGPoint startPoint, CGPoint endPoint, CGFloat len, bool *flag) {
    CGFloat l0 = sqrt(pow(startPoint.x - endPoint.x, 2) + pow(startPoint.y - endPoint.y, 2));
    CGFloat l1 = l0 + len;
 
    if (l0 < 0.01) {
        *flag = false;
        return CGPointZero;
    } else {
        *flag = true;
    }
    
    CGFloat sinA = (endPoint.y - startPoint.y) / l0;
    CGFloat cosA = (endPoint.x - startPoint.x) / l0;
    
    CGFloat x = l1 * cosA + startPoint.x;
    CGFloat y = l1 * sinA + startPoint.y;
    
    return CGPointMake(x, y);
}

bool CMIsPointInRect(CGPoint point, CGRect rect) {
    CGFloat pX = point.x;
    CGFloat pY = point.y;
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    if (pX > minX && pX < maxX && pY > minY && pY < maxY) {
        return true;
    }
    
    return false;
}

CGPoint CMGetProjectionCoordinateInLine(CGPoint sourcePoint, CGPoint linePoint, CGFloat k) {
    //y = k * x - linePoint.x * k + linePoint.y
    //y = -1/k * x - sourcePoint.x * -1/k + sourcePoint.y;
    //(k + 1/k) * x = linePoint.x * k - linePoint.y  - sourcePoint.x * -1/k + sourcePoint.y
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (fabs(k) < 0.001) {
        y = linePoint.y;
        x = sourcePoint.x;
    } else {
        x = (linePoint.x * k - linePoint.y + sourcePoint.x /k + sourcePoint.y) / (k + 1/k);
        y = k * x - linePoint.x * k + linePoint.y;
    }
    
    return CGPointMake(x, y);
}


CGPoint CMGetProjectionCoordinateInLine2(CGPoint sourcePoint, CGPoint linePoint0, CGPoint linePoint1) {
    if (fabs(linePoint1.x - linePoint0.x) < 1) {
        CGFloat x = linePoint0.x;
        CGFloat y = sourcePoint.y;
        
        return CGPointMake(x, y);
    }
    
    CGFloat k = (linePoint1.y - linePoint0.y) / (linePoint1.x - linePoint0.x);
    
    return CMGetProjectionCoordinateInLine(sourcePoint, linePoint0, k);
}

//获取直线上的某个点y坐标
CGFloat CMGetPointXWithPointYAndLine(CGFloat pointY, CGPoint linePoint0, CGPoint linePoint1) {
    // k = (linePoint1.y - linePoint1.y)/(linePoint1.x - linePoint0.x);
    // y = k * (x - linePoint0.x) + linePoint0.y;
    if (fabs(linePoint1.x - linePoint0.x) < 1) {
        printf("error: linePoint0.x == linePoint1.x\n");
        return linePoint0.x;
    }
    
    if (fabs(linePoint1.y - linePoint0.y) < 1) {
        printf("error: linePoint0.y == linePoint1.y\n");
        
        return linePoint0.x;
    }
    
    CGFloat k = (linePoint1.y - linePoint0.y)/(linePoint1.x - linePoint0.x);
    
    CGFloat x = (pointY - linePoint0.y) / k + linePoint0.x;
    
    return x;
}

//获取直线上的某个点x坐标
CGFloat CMGetPointYWithPointXAndLine(CGFloat pointX, CGPoint linePoint0, CGPoint linePoint1) {
    if (fabs(linePoint0.x - linePoint1.x) < 1) {
        printf("error:getPointYWithPointXAndLine()\n");
        return 0;
    }
    if (fabs(linePoint0.y - linePoint1.y) < 1) {
        return linePoint0.y;
    }
    
    CGFloat k = (linePoint1.y - linePoint0.y)/(linePoint1.x - linePoint0.x);
    
    CGFloat y = k * (pointX - linePoint0.x) + linePoint0.y;
    
    return y;
}
