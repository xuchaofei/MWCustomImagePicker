//
//  CustomAlertView.h
//  GetImages
//
//  Created by csm on 2018/1/12.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegate;

@interface CustomAlertView : UIView

@property (nonatomic, weak) id<CustomAlertViewDelegate > delegate;

@end

@protocol CustomAlertViewDelegate <NSObject>

-(void)alertView:(CustomAlertView *)customAlertView clickedButton:(NSString *)title;

@end
