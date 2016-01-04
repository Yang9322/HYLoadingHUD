//
//  HYLoadingHUD.h
//
//
//  Created by Yang on 1/4/16.
//  Copyright (c) 2015 Yang Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYLoadingHUD : UIView

// the HUD will show when call this method
+(void)show;

// the HUD will dismiss  when call this method
+(void)dismiss;

// set the backgroundView`s color(default is gray color)
+(void)setbackgroundViewColor:(UIColor *)color;

// set the backgroundView`s alpah value (default is 0.7)
+(void)setbackgroundAlpha:(CGFloat )value;

// set the ball`s color(default is blue color)
+(void)setBallColor:(UIColor *)color;

//this method is not recommendable，maybe you can try to modify
//+(void)setBallRadius:(CGFloat)radius;

@end
