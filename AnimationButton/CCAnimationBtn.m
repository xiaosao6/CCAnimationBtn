//
//  CCAnimationBtn.m
//  AnimationButton
//
//  Created by sischen on 2017/11/25.
//  Copyright © 2017年 pcbdoor.com. All rights reserved.
//

#import "CCAnimationBtn.h"

//线条颜色
//..........................


@interface CCAnimationBtn ()
//@property (nonatomic, assign) BOOL  chosen;
@property (nonatomic, strong) NSArray <CAShapeLayer *>  *lines;
@property (nonatomic, strong) CALayer  *imgLayer;
@property (nonatomic, strong) CALayer  *unChosenImgLayer;
@end

@implementation CCAnimationBtn

#pragma mark -
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.layer.masksToBounds = YES;
//    self.layer.borderColor = [UIColor grayColor].CGColor;
//    self.layer.borderWidth = 2;
    
    [self.layer addSublayer:self.unChosenImgLayer];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.chosen = !self.chosen;
//}

#pragma mark -
#pragma mark - make Animations
-(void)makeChosenAnimation{
    self.userInteractionEnabled = NO;
    [CATransaction setCompletionBlock:^{
        self.userInteractionEnabled = YES;
        for (CAShapeLayer *line in self.lines) { [line removeFromSuperlayer]; }
    }];
    
    [CATransaction begin];
    
    [self makeAnimationWithUnChosenImageFrom:@1 To:@0];
    
    [self.layer addSublayer:self.imgLayer];
    [self makeComingAnimationWithCenterImage];
    
    for (CAShapeLayer *line in self.lines) {
        [self.layer addSublayer: line];
        [self makeAnimationWithLine:line];
    }
    [CATransaction commit];
}

-(void)makeUnchosenAnimation{
    self.userInteractionEnabled = NO;
    [CATransaction setCompletionBlock:^{
        self.userInteractionEnabled = YES;
    }];
    
    [CATransaction begin];
    
    [self makeAnimationWithUnChosenImageFrom:@0 To:@1];
    [self makeFadingAnimationWithCenterImage];
    
    [CATransaction commit];
}

-(void)makeAnimationWithUnChosenImageFrom:(id)from To:(id)to {
    //透明度动画
    CABasicAnimation *anim_opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim_opacity.fillMode = kCAFillModeForwards;
    anim_opacity.removedOnCompletion = NO;
    anim_opacity.duration = animationTime/4.0;
    anim_opacity.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    
    anim_opacity.fromValue = from;
    anim_opacity.toValue   = to;
    [self.unChosenImgLayer addAnimation:anim_opacity forKey:@"opacity"];
}

-(void)makeFadingAnimationWithCenterImage {
    CABasicAnimation *anim_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim_scale.duration = animationTime/4.0;
    anim_scale.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionDefault];
    
    anim_scale.fromValue = @1;
    anim_scale.toValue   = @0;
    [self.imgLayer addAnimation:anim_scale forKey:@"scale"];
}

-(void)makeComingAnimationWithCenterImage {
    self.imgLayer.affineTransform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [self.imgLayer addAnimation:[self imgSpringAnimationWithKeyPath:@"transform.scale" From:@0.1 To:@1.0 BeginTime:animationTime/4.0] forKey:@"scale"];
    
    NSNumber *from  = [NSNumber numberWithFloat:-0.08 * M_PI];
    NSNumber *to    = [NSNumber numberWithFloat:0.0];
    [self.imgLayer addAnimation:[self imgSpringAnimationWithKeyPath:@"transform.rotation.z" From:from To:to BeginTime:animationTime/3.6] forKey:@"rotation"];
}

-(void)makeAnimationWithLine:(CAShapeLayer *)line {
    //缩放动画
    CABasicAnimation *anim_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim_scale.duration = animationTime/4.0;
    anim_scale.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    
    anim_scale.fromValue = @0.01;
    anim_scale.toValue   = @1.00;
    [line addAnimation:anim_scale forKey:@"scale"];
    
    //位移动画
    NSInteger index = [self.lines indexOfObject:line];
    CGFloat maxSize = MAX(self.bounds.size.width, self.bounds.size.height);
    double moveLength = (maxSize * 0.5) / sin(2 * M_PI/lineCount);
    double xRange = moveLength * sin((2 * M_PI/lineCount) *(index + 1));
    double yRange = moveLength * cos((2 * M_PI/lineCount) *(index + 1));
    
    CABasicAnimation *anim_trans = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    anim_trans.fillMode = kCAFillModeForwards;
    anim_trans.removedOnCompletion = NO;
    anim_trans.beginTime = CACurrentMediaTime() + animationTime/4.0;
    anim_trans.duration = animationTime/4.0;
    anim_trans.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    
    anim_trans.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    anim_trans.toValue   = [NSValue valueWithCGPoint:CGPointMake(xRange, -yRange)];
    [line addAnimation:anim_trans forKey:@"translation"];
}

#pragma mark -
#pragma mark - Private
-(CASpringAnimation *)imgSpringAnimationWithKeyPath:(NSString *)keypath From:(id)from To:(id)to BeginTime:(CFTimeInterval)beginTime{
    CASpringAnimation *anim_spring = [CASpringAnimation animationWithKeyPath:keypath];
    anim_spring.fillMode = kCAFillModeForwards;
    anim_spring.removedOnCompletion = NO;
    anim_spring.fromValue = from;
    anim_spring.toValue   = to;
    anim_spring.beginTime = CACurrentMediaTime() + beginTime;
    anim_spring.duration = animationTime/2.0;
    anim_spring.speed = 1.0/animationTime;
    
    anim_spring.mass = 1;
    anim_spring.damping = 8;
    anim_spring.stiffness = 180;
    anim_spring.initialVelocity = 8;
    
    return anim_spring;
}

#pragma mark -
#pragma mark - getter/setter
-(CALayer *)imgLayer{
    if (!_imgLayer) {
        _imgLayer = [CALayer layer];
//        _imgLayer.borderColor = [UIColor grayColor].CGColor;
//        _imgLayer.borderWidth = 2;
        CGFloat minlength = MIN(self.frame.size.width, self.frame.size.height);
        _imgLayer.contents = (__bridge id)([UIImage imageNamed:@"heart-icon"].CGImage);
        _imgLayer.frame = CGRectMake(self.frame.size.width / 2 - 0.5 * minlength * imgSizePercent,
                                     self.frame.size.height / 2 - 0.5 * minlength * imgSizePercent,
                                     minlength * imgSizePercent,
                                     minlength * imgSizePercent);
    }
    return _imgLayer;
}

-(CALayer *)unChosenImgLayer{
    if (!_unChosenImgLayer) {
        _unChosenImgLayer = [CALayer layer];
        _unChosenImgLayer.contents = (__bridge id)([UIImage imageNamed:@"heart-icon-unchosen"].CGImage);
        _unChosenImgLayer.frame = self.imgLayer.frame;
    }
    return _unChosenImgLayer;
}

-(NSArray<CAShapeLayer *> *)lines{
    if (!_lines) {
        CGRect lineFrame = CGRectMake(0, 0, self.frame.size.width * lineLengthPercent, self.frame.size.height * lineLengthPercent);
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (int i=0; i<lineCount; i++) {
            CAShapeLayer *lineLayer   = [CAShapeLayer layer];
            lineLayer.bounds          = self.frame;
            lineLayer.position = CGPointMake(CGRectGetMidX(self.imgLayer.frame), CGRectGetMidY(self.imgLayer.frame));
            lineLayer.backgroundColor = [UIColor colorWithRed:0.9686 green:0.2863 blue:0.4471 alpha:1].CGColor;
            
            CAShapeLayer *lineMask = [CAShapeLayer layer];
            CGMutablePathRef shapePath = CGPathCreateMutable();
            CGPathMoveToPoint(shapePath, nil, CGRectGetMidX(lineFrame), CGRectGetMidY(lineFrame));
            CGPathAddLineToPoint(shapePath, nil, lineFrame.origin.x + lineFrame.size.width / 2 + 0.5*lineWidth, lineFrame.origin.y);
            CGPathAddLineToPoint(shapePath, nil, lineFrame.origin.x + lineFrame.size.width / 2 - 0.5*lineWidth, lineFrame.origin.y);
            CGPathAddLineToPoint(shapePath, nil, CGRectGetMidX(lineFrame), CGRectGetMidY(lineFrame));
            lineMask.path = shapePath;
            CGPathRelease(shapePath);
            
            lineMask.bounds = lineFrame;
            lineMask.position = self.center;
            lineMask.fillColor = [UIColor whiteColor].CGColor;
            lineMask.fillRule = kCAFillRuleEvenOdd;
            
            lineLayer.transform = CATransform3DMakeRotation((2 * M_PI / lineCount) * (i + 1), 0.0, 0.0, 1.0);
            lineLayer.mask = lineMask;
            
            [tmpArr addObject: lineLayer];
        }
        _lines = [NSArray<CAShapeLayer *> arrayWithArray:tmpArr];
    }
    return _lines;
}

//-(void)setChosen:(BOOL)chosen{
//    _chosen = chosen;
//    if (_chosen) {
//        [self makeChosenAnimation];
//    }else{
//        [self makeUnchosenAnimation];
//    }
//}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self makeChosenAnimation];
    }else{
        [self makeUnchosenAnimation];
    }
}

@end
