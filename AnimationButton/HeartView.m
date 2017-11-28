//
//  HeartView.m
//  AnimationButton
//
//  Created by sischen on 2017/11/28.
//Copyright © 2017年 pcbdoor.com. All rights reserved.
//

#import "HeartView.h"

@implementation HeartView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 左右间距
    CGFloat padding = 4.0;
    // 半径(小圆半径)
    CGFloat curveRadius = ((rect.size.width - 2 * padding)/2.0) / (cos(2 * M_PI/8.0) + 1.0);
    // 贝塞尔曲线
    UIBezierPath *heartPath = [UIBezierPath bezierPath];
    // 起点(底部，圆的第一个点)
    CGPoint tipLocation = CGPointMake(rect.size.width/2, rect.size.height-padding);
    // 从起点开始画
    [heartPath moveToPoint:tipLocation];
    // (左圆的第二个点)
    CGPoint topLeftCurveStart = CGPointMake(padding, rect.size.height/2.8);
    // 添加二次曲线
    [heartPath addQuadCurveToPoint:topLeftCurveStart controlPoint:CGPointMake(topLeftCurveStart.x, topLeftCurveStart.y + curveRadius)];
    // 画圆
    [heartPath addArcWithCenter:CGPointMake(topLeftCurveStart.x+curveRadius, topLeftCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:-M_PI*0.25 clockwise:YES];
    // (左圆的第二个点)
    CGPoint topRightCurveStart = CGPointMake((rect.size.width - padding) - curveRadius, topLeftCurveStart.y);
    // 画圆
    [heartPath addArcWithCenter:CGPointMake(topRightCurveStart.x, topRightCurveStart.y) radius:curveRadius startAngle:-M_PI*0.75 endAngle:0 clockwise:YES];
    // 右上角控制点
    CGPoint topRightCurveEnd = CGPointMake((rect.size.width - padding), topLeftCurveStart.y);
    // 添加二次曲线
    [heartPath addQuadCurveToPoint:tipLocation controlPoint:CGPointMake(topRightCurveEnd.x, topRightCurveEnd.y+curveRadius)];
    // 设置填充色
    [[UIColor colorWithRed:0.9686 green:0.2863 blue:0.4471 alpha:1] setFill];
    // 填充
    [heartPath fill];
    // 设置边线
    heartPath.lineWidth = 0.5;
    heartPath.lineCapStyle  = kCGLineCapRound;
    heartPath.lineJoinStyle = kCGLineJoinRound;
    // 设置描边色
    [[UIColor colorWithRed:0.9686 green:0.2863 blue:0.4471 alpha:1] setStroke];
    [heartPath stroke];
}


@end
