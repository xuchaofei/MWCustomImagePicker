//
//  MWPhotoViewController.h
//  MWCustomImagePicker
//
//  Created by csm on 2018/1/16.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MWPhotoViewControllerDelegate;

@interface MWPhotoViewController : UIViewController

@property (nonatomic, strong) NSArray* lastSelectedPhotos;

@property (nonatomic, weak) id<MWPhotoViewControllerDelegate> delegate;

@end

@protocol MWPhotoViewControllerDelegate <NSObject>

-(void)photoViewController:(MWPhotoViewController *)photoVC chooseImages:(NSArray *)choosedImagesArray;

@end
