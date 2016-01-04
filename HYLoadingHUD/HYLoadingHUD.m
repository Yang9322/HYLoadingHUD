//
//  HYLoadingHUD.h
//
//
//  Created by Yang on 1/4/16.
//  Copyright (c) 2015 Yang Yang. All rights reserved.
//

#define ORIGIN_X    self.frame.origin.x
#define ORIGIN_Y    self.frame.origin.y
#define WIDTH       self.frame.size.width
#define HEIGHT      self.frame.size.height
#define BALL_RADIUS  20
#import "HYLoadingHUD.h"


@interface HYLoadingHUD()
@property (nonatomic,assign)BOOL stop;
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic,strong)UIColor *backgroundViewColor;
@property (nonatomic,assign)CGFloat backgroundAlpha;
@property (nonatomic,strong)UIColor *hudColor;
@property (nonatomic,strong)UIColor *ballColor;
@property (nonatomic,assign)CGFloat ballRadius;


@end

@implementation HYLoadingHUD{
    UIView *ball_1;
    UIView *ball_2;
    UIView *ball_3;
    
    

}
static CGRect originaiFrame;


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = WIDTH /2;
        self.clipsToBounds = YES;
    }
    return self;
}


+(HYLoadingHUD *)sharedView{
    static dispatch_once_t once;
    static HYLoadingHUD *sharedView;
    dispatch_once(&once, ^ { sharedView = [[self alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
        originaiFrame = sharedView.frame;
    });
    return sharedView;
}


+(void)setbackgroundViewColor:(UIColor *)color{
    [HYLoadingHUD sharedView].backgroundViewColor = color;
}

+(void)setbackgroundAlpha:(CGFloat)value{
    [HYLoadingHUD sharedView].backgroundAlpha = value;
}


+(void)setBallColor:(UIColor *)color{
    [HYLoadingHUD sharedView].ballColor = color;
}

+(void)setBallRadius:(CGFloat)radius{
    [HYLoadingHUD sharedView].ballRadius = radius;
}




+(void)show{
    
    [[self sharedView] showHUD];;
    
    
}

+(void)dismiss{
    [[self sharedView] dismissHUD];;
}





- (void)dismissHUD {
    
    _stop = 1;

    
    [UIView animateWithDuration:1 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 0;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [self.layer removeAllAnimations];

    }];
}
    





-(void)showHUD{
    
    
    for (id view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"HYLoadingHUD")]) {
            [view removeFromSuperview];
        }
    }
    
    for (id view in self.subviews) {
        [view removeFromSuperview];
    }
    
    _stop = 0;

    self.alpha = 1;

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    static dispatch_once_t once;

    if (!_backgroundView) {
        dispatch_once(&once, ^ { _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
           

        });
    }
    
    
    
    
    if (_backgroundViewColor) {
        _backgroundView.backgroundColor = _backgroundViewColor;
    }else
    {
        _backgroundView.backgroundColor = [UIColor grayColor];
    }
   
    [[UIApplication sharedApplication].keyWindow addSubview:_backgroundView];
    if (_backgroundAlpha) {
        _backgroundView.alpha = _backgroundAlpha;

    }else{
        _backgroundView.alpha = 0.7;
 
    }
    
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    
    ball_2 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2 - BALL_RADIUS/2, HEIGHT / 2-BALL_RADIUS/2, BALL_RADIUS, BALL_RADIUS)];
    
    ball_2.backgroundColor = _ballColor? _ballColor:[UIColor blueColor];
    ball_2.layer.cornerRadius = ball_2.bounds.size.width / 2;
    
    ball_1 = [[UIView alloc]initWithFrame:CGRectMake(ball_2.frame.origin.x - BALL_RADIUS, ball_2.frame.origin.y, BALL_RADIUS, BALL_RADIUS)];
    ball_1.backgroundColor = _ballColor? _ballColor:[UIColor blueColor];
    ball_1.layer.cornerRadius = ball_1.bounds.size.width / 2;
    
    ball_3 = [[UIView alloc]initWithFrame:CGRectMake(ball_2.frame.origin.x + BALL_RADIUS, ball_2.frame.origin.y, BALL_RADIUS, BALL_RADIUS)];
    ball_3.backgroundColor = _ballColor? _ballColor:[UIColor blueColor];
    ball_3.layer.cornerRadius = ball_3.bounds.size.width / 2;
    
    [self addSubview:ball_1];
    [self addSubview:ball_2];
    [self addSubview:ball_3];
    [self startLoadingAnimation];
    
}

-(void)startLoadingAnimation{
    
    UIBezierPath *circlePath_1 = [UIBezierPath bezierPath];
    [circlePath_1 moveToPoint:CGPointMake(WIDTH/2-BALL_RADIUS, HEIGHT/2)];
    
    [circlePath_1 addArcWithCenter:CGPointMake(WIDTH/2, HEIGHT/2) radius:BALL_RADIUS startAngle:(180*M_PI)/180 endAngle:(360*M_PI)/180 clockwise:NO];
    
 


    UIBezierPath *circlePath_1_2 = [UIBezierPath bezierPath];
    [circlePath_1_2 addArcWithCenter:CGPointMake(WIDTH/2, HEIGHT/2) radius:BALL_RADIUS startAngle:0 endAngle:(180*M_PI)/180 clockwise:NO];
    [circlePath_1 appendPath:circlePath_1_2];
    
    
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = circlePath_1.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.calculationMode = kCAAnimationCubic;
    animation.repeatCount = 1;
    animation.duration = 1.4;
    animation.delegate = self;
    //    animation.beginTime = 0.1;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    [ball_1.layer addAnimation:animation forKey:@"animation"];
    
    
    UIBezierPath *circlePath_2 = [UIBezierPath bezierPath];
    [circlePath_2 moveToPoint:CGPointMake(WIDTH/2+BALL_RADIUS, HEIGHT/2)];
    
    [circlePath_2 addArcWithCenter:CGPointMake(WIDTH/2, HEIGHT/2) radius:BALL_RADIUS startAngle:0 endAngle:M_PI clockwise:NO];
    UIBezierPath *circlePath_2_2 = [UIBezierPath bezierPath];
    [circlePath_2_2 addArcWithCenter:CGPointMake(WIDTH/2, HEIGHT/2) radius:BALL_RADIUS startAngle:M_PI endAngle:2 * M_PI clockwise:NO];
    [circlePath_2 appendPath:circlePath_2_2];
    
    
    CAKeyframeAnimation *animation_2=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation_2.path = circlePath_2.CGPath;
    animation_2.removedOnCompletion = NO;
    animation_2.fillMode = kCAFillModeForwards;
    animation_2.repeatCount = 1;
    //    animation_2.beginTime = 0.1;
    animation_2.duration =1.4 ;
    animation_2.autoreverses = NO;
    animation_2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [ball_3.layer addAnimation:animation_2 forKey:@"Rotation"];
    
}


- (void)animationDidStart:(CAAnimation *)anim{
    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        ball_1.transform = CGAffineTransformMakeTranslation(-BALL_RADIUS, 0);
        ball_1.transform = CGAffineTransformScale(ball_1.transform, 0.7, 0.7);
        
        ball_3.transform = CGAffineTransformMakeTranslation(BALL_RADIUS, 0);
        ball_3.transform = CGAffineTransformScale(ball_3.transform, 0.7, 0.7);
        
        ball_2.transform = CGAffineTransformScale(ball_2.transform, 0.7, 0.7);
        
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn  | UIViewAnimationOptionBeginFromCurrentState animations:^{
            ball_1.transform = CGAffineTransformIdentity;
            ball_3.transform = CGAffineTransformIdentity;
            ball_2.transform = CGAffineTransformIdentity;
            
        } completion:nil];
    }];
    
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (_stop) {
        [self.layer removeAllAnimations];
        
    }else{
        [self startLoadingAnimation];
    }
    
}





@end


