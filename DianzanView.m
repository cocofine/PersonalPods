//
//  DianzanView.m
//  dianzan
//
//  Created by ouyangqi on 2018/10/18.
//  Copyright © 2018年 ouyangqi. All rights reserved.
//

#import "DianzanView.h"
#import<AudioToolbox/AudioToolbox.h>

@interface DianzanView ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation DianzanView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initMethod];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initMethod];
    }
    return self;
}

-(void)initMethod
{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    self.imgView.center = CGPointMake(self.frame.size.width/2, 18);
    self.imgView.image = [UIImage imageNamed:@"ic_messages_like_selected_shining"];
    self.imgView.hidden = YES;
    [self addSubview:self.imgView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, 60, 60);
    self.button.adjustsImageWhenHighlighted = NO;
    self.button.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    [self.button setImage:[UIImage imageNamed:@"ic_messages_like"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.button addTarget:self action:@selector(btnDownAction:) forControlEvents:UIControlEventTouchDown];
    [self.button addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchDragOutside];
    [self addSubview:self.button];
    
}

-(void)btnCancelAction:(UIButton *)btn
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.button.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

-(void)btnDownAction:(UIButton *)btn
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.button.transform = CGAffineTransformMakeScale(0.8,0.8);
    [UIView commitAnimations];
}

-(void)btnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    AudioServicesPlaySystemSound(1519);
    if (btn.selected)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.imgView.hidden = NO;
        });
        
        [self.button setImage:[UIImage imageNamed:@"ic_messages_like_selected"] forState:UIControlStateNormal];
        [self pathAnimation];
    }
    else
    {
        self.imgView.hidden = YES;
        [self.button setImage:[UIImage imageNamed:@"ic_messages_like"] forState:UIControlStateNormal];
    }
    
    //-----
    
    [UIView animateWithDuration:0.3 animations:^{
        self.button.transform = CGAffineTransformMakeScale(0.8,0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.button.transform = CGAffineTransformMakeScale(1.1,1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.button.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {

            }];
        }];
    }];

}


-(void)pathAnimation
{
    UIBezierPath *path6 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.button.frame.origin.x - 2, self.button.frame.origin.y - 2, self.button.frame.size.width + 4, self.button.frame.size.height + 4)];
    [path6 stroke];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    layer.path = path6.CGPath;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.lineWidth = 2;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor colorWithRed:212/255.0 green:97/255.0 blue:72/255.0 alpha:1].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:layer];
    layer.allowsEdgeAntialiasing = YES;
    
    //
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.4;
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:2.3];
    [layer addAnimation:animation forKey:@"strokeEndAnimation"];
    
    CABasicAnimation *basicAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation2.fromValue = @(1.0);
    basicAnimation2.toValue = @(0.0);
    basicAnimation2.duration = 0.4;
    [layer addAnimation:basicAnimation2 forKey:@"op"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
    });
}


@end
