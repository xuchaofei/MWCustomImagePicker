//
//  MKInagePickerViewController.m
//  MWCustomImagePicker
//
//  Created by csm on 2018/1/16.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import "MKInagePickerViewController.h"
#import "CustomAlertView.h"
#import "MWPhotoViewController.h"
#import "MWPhoto.h"

#define screenwidth [UIScreen mainScreen].bounds.size.width

@interface MKInagePickerViewController ()<CustomAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoViewControllerDelegate>{
    
    NSArray * _lastChooseImageArray;
}

@property (nonatomic, weak) UIButton * selectedButton;
@end

@implementation MKInagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_lastChooseImageArray) {
        _lastChooseImageArray = [[NSMutableArray alloc] init];
    }

    self.navigationItem.title = @"选择图片";
    
    [self setUpSelectedButton];
}

-(void)setUpSelectedButton{
    
    NSArray * titleArray = @[@"选择一张图片",@"选择所有图片"];
    for (int i = 0; i < 2; i++) {
        CGFloat imageButtonY = 100 + i * (80 + 30);
        UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(150, imageButtonY, 150, 80);
        [imageButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        imageButton.tag = i;
        [imageButton addTarget:self action:@selector(chooseGetImageStyle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:imageButton];
        if (i == 1) {
            _selectedButton = imageButton;
        }
    }
    
}

-(void)chooseGetImageStyle:(UIButton *)sender{
    
    NSInteger buttonTag = sender.tag;
    
    if (buttonTag == 0) {
        
        CustomAlertView * alertView = [[CustomAlertView alloc] init];
        alertView.delegate = self;
        [self.view addSubview:alertView];
        
    }else{
        
        [self getImageFromPhotoLibrary];
        
    }
}

#pragma mark -- 自定义AlertView的点击事件的代理方法

-(void)alertView:(CustomAlertView *)customAlertView clickedButton:(NSString *)title{
    if ([title isEqualToString:@"拍照"]) {
        
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.navigationBar.tintColor = [UIColor blackColor];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            imagePicker.modalPresentationCapturesStatusBarAppearance = YES;
            imagePicker.allowsEditing = NO;
            imagePicker.delegate = self;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else{
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }else if ([title isEqualToString:@"从相册选取图片"]){
        
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.navigationBar.tintColor = [UIColor blackColor];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
    
}

#pragma mark -- UIImagePickerControllerDelegate的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString * type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        
        UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //关闭相册界面
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
       
        NSLog(@"输出的是视频文件!");
    }
}

#pragma mark -- 选取完图片后自动消失
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -- 从本地获取全部图片
-(void)getImageFromPhotoLibrary{
    
    MWPhotoViewController * photoVC = [[MWPhotoViewController alloc] init];
    photoVC.delegate = self;
    photoVC.lastSelectedPhotos = _lastChooseImageArray;
    [self.navigationController pushViewController:photoVC animated:YES];
}

-(void)photoViewController:(MWPhotoViewController *)photoVC chooseImages:(NSArray *)choosedImagesArray{
    
    _lastChooseImageArray = choosedImagesArray;
    
    CGFloat startImageViewY = CGRectGetMaxY(_selectedButton.frame) + 20;
    
    CGFloat space = 10;
    
    CGFloat imageWidth = (screenwidth - 4 * space)/3;
    
    for (int i = 0; i < choosedImagesArray.count; i++) {
        
        MWPhoto * photo = choosedImagesArray[i];
        
        int lines = i % 3;
        int rows = i / 3;
        
        CGFloat imageViewX = 10 + lines * (imageWidth + 10);
        CGFloat imageViewY = startImageViewY + rows * (imageWidth + 10);

        UIImageView * chooseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageWidth, imageWidth)];
        chooseImageView.image = photo.thumbnail;
        [self.view addSubview:chooseImageView];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
