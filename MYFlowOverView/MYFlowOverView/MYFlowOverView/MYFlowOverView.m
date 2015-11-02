//
//  MYFlowOverView.m
//
//  Created by 梦阳 许 on 15/10/28.
//  Copyright © 2015年 X-my. All rights reserved.
//

#import "MYFlowOverView.h"

#define MYFlowOverView_DEFAULT_LINE_WIDTH               2.0f
#define MYFlowOverView_DEFAULT_ANIMATE_DURATION         0.5f
#define MYFlowOverView_DEFAULT_CLOSE_BUTTON_SIZE        30.0f
#define MYFlowOverView_DEFAULT_CONTENT_CORNER_RADIUS    5.0f

@interface MYFlowOverView ()

{
    UIView* targetView;
    UIView* contentView;
    UIButton* closeButton;
    UIView* lineView;
    
    CGRect targetFrame;
    CGRect lineFinalFrame;
    CGRect contentFinalFrame;
}

@end

@implementation MYFlowOverView
@synthesize contentView = contentView;

#pragma mark - Initialize

- (instancetype)initWithTargetView:(UIView*)target contentView:(UIView*)content
{
    self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        
        UIWindow* superView = [UIApplication sharedApplication].windows.firstObject;
        targetFrame = [target.superview convertRect:target.frame toView:superView];
        
        targetView = target;
        contentView = content;
        
        [self setupDefaultConfig];
        [self setupSubviews];
        [self setupSubviewsFinalFrame];
    }
    return self;
}
- (void)setupDefaultConfig
{
    _lineWidth = MYFlowOverView_DEFAULT_LINE_WIDTH;
    _animateDuration = MYFlowOverView_DEFAULT_ANIMATE_DURATION;
    _tintColor = [UIColor whiteColor];
    _contentCornerRadius = MYFlowOverView_DEFAULT_CONTENT_CORNER_RADIUS;
    
    _flowDirection = MYFlowOverViewFlowDirectionDown;
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
}
- (void)setupSubviews
{
    contentView.contentMode = UIViewContentModeScaleAspectFill;
    contentView.clipsToBounds = YES;
    contentView.layer.cornerRadius = _contentCornerRadius;
    [self addSubview:contentView];
    
    closeButton = [[UIButton alloc]init];
    [closeButton setImage:[self imageOfClose] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];

    lineView = [[UIView alloc]init];
    lineView.backgroundColor = _tintColor;
    [self addSubview:lineView];

}
- (void)setupSubviewsFinalFrame
{
    closeButton.frame = CGRectMake(0, 0, MYFlowOverView_DEFAULT_CLOSE_BUTTON_SIZE, MYFlowOverView_DEFAULT_CLOSE_BUTTON_SIZE);
    closeButton.center = CGPointMake(CGRectGetMidX(targetFrame), CGRectGetMidY(targetFrame));
    
    if (!self.needCustomContentOrigin) {
        self.contentView.center = self.center;
    }
    contentFinalFrame = self.contentView.frame;
    
    CGFloat lineW = self.lineWidth;
    CGFloat lineX = closeButton.frame.origin.x + (closeButton.frame.size.width - lineW)/2;
    CGFloat lineY = 0;
    CGFloat lineH = 0;
    
    switch (self.flowDirection) {
        case MYFlowOverViewFlowDirectionDown:
            lineY = CGRectGetMaxY(closeButton.frame);
            lineH = CGRectGetMinY(contentFinalFrame) - CGRectGetMaxY(closeButton.frame);
            break;
        case MYFlowOverViewFlowDirectionUp:
            lineY =CGRectGetMaxY(contentFinalFrame);
            lineH = CGRectGetMinY(closeButton.frame) - CGRectGetMaxY(contentFinalFrame);
            break;
    }
    
    lineFinalFrame = CGRectMake(lineX, lineY, lineW, lineH);
    lineView.frame = lineFinalFrame;
    
}

#pragma mark - Setter
- (void)setFlowDirection:(MYFlowOverViewFlowDirection)flowDirection
{
    if (flowDirection == _flowDirection) return;
    
    _flowDirection  = flowDirection;
    
    [self setupSubviewsFinalFrame];
}
- (void)setContentCornerRadius:(CGFloat)contentCornerRadius
{
    _contentCornerRadius = contentCornerRadius;
    contentView.layer.cornerRadius = contentCornerRadius;
}
#pragma mark - Animations

- (CGRect)originalFrameBeforeAnimate:(CGRect)finalFrame
{
    CGRect frame = finalFrame;
    if (self.flowDirection == MYFlowOverViewFlowDirectionUp) {
        frame.origin.y += frame.size.height;
    }
    frame.size.height = 0;
    return frame;
}
- (void)closeButtonClicked:(UIButton*)sender
{
    [self dismiss];
}

- (void)show
{
    targetView.hidden = YES;
    [[UIApplication sharedApplication].windows.firstObject addSubview:self];
    self.alpha = 0;
    
    lineView.frame = [self originalFrameBeforeAnimate:lineFinalFrame];
    contentView.frame = [self originalFrameBeforeAnimate:contentFinalFrame];
    
    [UIView animateKeyframesWithDuration:self.animateDuration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0
                                relativeDuration:1/10.0
                                      animations:^{
                                          self.alpha = 1;
                                      }];
        [UIView addKeyframeWithRelativeStartTime:1/10.0
                                relativeDuration:2/5.0
                                      animations:^{
                                          lineView.frame = lineFinalFrame;
                                      }];
        [UIView addKeyframeWithRelativeStartTime:0.5
                                relativeDuration:0.5
                                      animations:^{
                                          contentView.frame = contentFinalFrame;
                                      }];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateKeyframesWithDuration:self.animateDuration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0
                                relativeDuration:0.5
                                      animations:^{
                                          contentView.frame = [self originalFrameBeforeAnimate:contentFinalFrame];
                                      }];
        [UIView addKeyframeWithRelativeStartTime:0.5
                                relativeDuration:2/5.0
                                      animations:^{
                                          lineView.frame = [self originalFrameBeforeAnimate:lineFinalFrame];
                                      }];
        [UIView addKeyframeWithRelativeStartTime:9/10.0
                                relativeDuration:1/10.0
                                      animations:^{
                                          self.alpha = 0;
                                      }];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        targetView.hidden = NO;
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.2)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [targetView.layer addAnimation:k forKey:@"SHOW"];
    }];
}

#pragma mark - Draw Colse Button

- (UIImage*)imageOfClose
{
    CGSize size = CGSizeMake(MYFlowOverView_DEFAULT_CLOSE_BUTTON_SIZE , MYFlowOverView_DEFAULT_CLOSE_BUTTON_SIZE);
    CGFloat gap = size.width/3;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    UIBezierPath *crossShapePath = [[UIBezierPath alloc] init];
    crossShapePath.lineCapStyle = kCGLineCapRound;
    crossShapePath.lineJoinStyle = kCGLineJoinRound;
    
    [self.tintColor setStroke];
    crossShapePath.lineWidth = self.lineWidth;
    
    [crossShapePath moveToPoint:CGPointMake(gap, size.width - gap)];
    [crossShapePath addLineToPoint:CGPointMake(size.width - gap, gap)];
    [crossShapePath moveToPoint:CGPointMake(gap, gap)];
    [crossShapePath addLineToPoint:CGPointMake(size.width - gap, size.width -gap)];
    [crossShapePath stroke];

    [crossShapePath removeAllPoints];
    [crossShapePath addArcWithCenter:CGPointMake(size.width/2, size.height/2) radius:size.width/2 - self.lineWidth+1 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [crossShapePath stroke];
    
    UIImage* closeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return closeImage;
}
@end
