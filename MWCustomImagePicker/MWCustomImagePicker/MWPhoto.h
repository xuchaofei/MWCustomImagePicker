//
//  MWPhoto.h
//  MWCustomImagePicker
//
//  Created by csm on 2018/1/16.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MWPhoto : NSObject

@property (nonatomic, strong) UIImage * thumbnail;

@property (nonatomic, strong) NSURL * URL;

@property (nonatomic, getter=isSelected) BOOL selected;

@end
