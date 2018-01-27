//
//  CustomAlertView.m
//  GetImages
//
//  Created by csm on 2018/1/12.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import "CustomAlertView.h"

#define screenwidth [UIScreen mainScreen].bounds.size.width
#define screenheight [UIScreen mainScreen].bounds.size.height
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

static CGFloat buttonheight = 60;

@interface CustomAlertView ()

@property (nonatomic, weak) UIView * shadowView;

@end

@implementation CustomAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       
    }
    return self;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self setUpDetailUI];

    }
    return self;
}

-(void)setUpDetailUI{
    
    UIWindow * currentWindow = [[UIApplication sharedApplication].delegate window];
    
    UIView * shadowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shadowView.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    [currentWindow.rootViewController.view addSubview:shadowView];
    _shadowView = shadowView;
    
    UITapGestureRecognizer * shadowTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeShadowView)];
    [shadowView addGestureRecognizer:shadowTap];
    
    NSArray * titleArray = @[@"取消",@"从相册选取图片",@"拍照"];
    
    for (int i = 0; i < 3; i++) {
        CGFloat selectButtonY = screenheight - (i + 1) * buttonheight;
        UIButton * selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.backgroundColor = [UIColor whiteColor];
        if (i == 1) {
            selectButtonY = selectButtonY - 10;
        }else if (i == 2){
            selectButtonY = selectButtonY - 10 - 1;
        }
        selectButton.frame = CGRectMake(0, selectButtonY, screenwidth, buttonheight);
        [selectButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        selectButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [selectButton addTarget:self action:@selector(chooseOneWayToGetImage:) forControlEvents:UIControlEventTouchUpInside];
        [shadowView addSubview:selectButton];
    }
}

-(void)chooseOneWayToGetImage:(UIButton *)sender{
    
    [_shadowView removeFromSuperview];

    if ([_delegate respondsToSelector:@selector(alertView:clickedButton:)]) {
        [self.delegate alertView:self clickedButton:sender.titleLabel.text];
    }
    
}

-(void)removeShadowView{
    
    [_shadowView removeFromSuperview];
}

@end
