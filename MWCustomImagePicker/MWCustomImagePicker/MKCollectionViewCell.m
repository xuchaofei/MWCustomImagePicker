//
//  MKCollectionViewCell.m
//  MWCustomImagePicker
//
//  Created by csm on 2018/1/16.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import "MKCollectionViewCell.h"

@implementation MKCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        
        [self.contentView addSubview:_imageView];
        
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _selectedButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - 40, 0, 40, 40);
        
        [_selectedButton setImage:[UIImage imageNamed:@"compose_photo_preview_default"] forState:UIControlStateNormal];
        
        [_selectedButton setImage:[UIImage imageNamed:@"compose_photo_preview_right"] forState:UIControlStateSelected];
        
        [_selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_selectedButton];
    }
    
    return self;
}

-(void)selectedButtonClick:(UIButton *)sender{
    
    //点击按钮不会触发 UIControlStateSelected 状态
    //需要修改 selected 属性
    
    BOOL isSelected = !sender.isSelected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(photoCell:shouldUpdateSelectedButtonState:)]) {
        
        BOOL result = [_delegate photoCell:self shouldUpdateSelectedButtonState:isSelected];
        
        if (result) {
            sender.selected = isSelected;
        }
    }
    
}
@end
