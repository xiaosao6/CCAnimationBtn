//
//  CCAnimationBtn.h
//  AnimationButton
//
//  Created by sischen on 2017/11/25.
//  Copyright © 2017年 pcbdoor.com. All rights reserved.
//

#import <UIKit/UIKit.h>


//线条数量
static const NSInteger lineCount = 6;
//线条末端宽度
static const CGFloat lineWidth = 11.5;
//线条长度相对控件半个尺寸比例
static const CGFloat lineLengthPercent = 0.75;
//动画总时长
static const CFTimeInterval animationTime = 1.1;
//中心图片相对控件尺寸比例
static const CGFloat imgSizePercent = 0.72;


@interface CCAnimationBtn : UIButton

@end
