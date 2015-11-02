//
//  MYFlowOverView.h
//
//  Created by 梦阳 许 on 15/10/28.
//  Copyright © 2015年 X-my. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {

    MYFlowOverViewFlowDirectionDown,    //top to bottom
    
    MYFlowOverViewFlowDirectionUp,      //bottom to top
    
} MYFlowOverViewFlowDirection;

@interface MYFlowOverView : UIView

@property (nonatomic, strong, readonly) UIView* contentView;

@property (nonatomic, assign) CGFloat contentCornerRadius;//default is 5.0f

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) UIColor* tintColor; //line and close button color

@property (nonatomic, assign) NSTimeInterval animateDuration;//default is 0.5s

@property (nonatomic, assign) BOOL needCustomContentOrigin;//default is NO,contentView will show in screen center

@property (nonatomic, assign) MYFlowOverViewFlowDirection flowDirection; //default is bottom



- (instancetype)initWithTargetView:(UIView*)target contentView:(UIView*)content;

- (void)show;

- (void)dismiss;

@end
