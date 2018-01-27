//
//  MKCollectionViewCell.h
//  MWCustomImagePicker
//
//  Created by csm on 2018/1/16.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKCollectionViewCellDelegate;

@interface MKCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UIButton * selectedButton;

@property (nonatomic, weak) id<MKCollectionViewCellDelegate> delegate;

@end

@protocol MKCollectionViewCellDelegate <NSObject>

//是否允许更改按钮的状态
- (BOOL)photoCell:(MKCollectionViewCell *)cell shouldUpdateSelectedButtonState:(BOOL)isSelected;

@end
