//
//  MWPhotoViewController.m
//  MWCustomImagePicker
//
//  Created by csm on 2018/1/16.
//  Copyright © 2018年 YiJu. All rights reserved.
//

#import "MWPhotoViewController.h"
#import "MKCollectionViewCell.h"
#import "MWPhoto.h"
#import <Photos/Photos.h>


@import AssetsLibrary;

#define screenwidth [UIScreen mainScreen].bounds.size.width
#define screenheight [UIScreen mainScreen].bounds.size.height
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface MWPhotoViewController ()<UICollectionViewDataSource,MKCollectionViewCellDelegate>{
    //全部图片
    NSMutableArray * _photos;
    //选中的图片
    NSMutableArray * _selectedPhotos;
}

@end

@implementation MWPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"相册";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat space = 5;
    
    CGFloat width = (self.view.frame.size.width - 10)/3;
    
    layout.itemSize = CGSizeMake(width, width);
    //最小行间距
    layout.minimumLineSpacing = space;
    //最小列间距
    layout.minimumInteritemSpacing = space;
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight-64) collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[MKCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    _photos = [[NSMutableArray alloc] initWithCapacity:0];
    
    _selectedPhotos = [[NSMutableArray alloc] initWithCapacity:0];
    
    CGFloat iphoneversion = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (iphoneversion < 8.0) {
        
        //1.照片容器对象
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        //2.遍历容器,取出每一组照片
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            //处理每一组(group)照片
            //3.遍历组, 获取每一张图片
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                //4.对每一组照片(result)进行处理
                //4.1 取出类型进行判断,只处理图片
                
                NSString * type = [result valueForProperty:ALAssetPropertyType];
                
                if ([type isEqualToString:ALAssetTypePhoto]) {
                    
                    //只对 Photo 类型进行处理
                    //4.2 把 result 中有用的属性封装为 model 类, 放入数组中保存
                    MWPhoto * photo = [[MWPhoto alloc] init];
                    
                    //缩略图
                    photo.thumbnail = [[UIImage alloc] initWithCGImage:result.thumbnail];
                    
                    UIImage * thumbnail = photo.thumbnail;
                    
                    //URL
                    photo.URL = [result valueForProperty:ALAssetPropertyAssetURL];
                    
                    for (MWPhoto * selectedPhoto in _lastSelectedPhotos) {
                        //URL:照片的唯一标示
                        if ([selectedPhoto.URL.absoluteString isEqualToString:photo.URL.absoluteString]) {
                            
                            photo.selected = YES;
                            
                            [_selectedPhotos addObject:photo];
                            
                            break;
                        }
                    }
                    
                    [_photos addObject:photo];
                }
            }];
            
            
            if (group == nil) {
                
                //异步加载图片,完成后需要刷新
                [collectionView reloadData];
                
            }
            
            
        } failureBlock:^(NSError *error) {
            NSLog(@"读取失败");
        }];
    }else{
        
        //PHAssetCollectionSubtypeAlbumRegular: 自定义相册
        //PHAssetCollectionSubtypeAlbumSyncedAlbum: 通过iTunes同步过来的相册
        // 获得所有的自定义相簿
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
       
        // 遍历所有的自定义相簿
        for (PHAssetCollection * assetCollection in assetCollections) {
            [self enumerateAssetsInAssetsCollection:assetCollection original:YES];
        }
        
        // 获得相机胶卷
        PHAssetCollection * camaraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        
        [self enumerateAssetsInAssetsCollection:camaraRoll original:YES];
    }

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MKCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.tag = indexPath.item;
    
    MWPhoto * photo = _photos[indexPath.item];
    
    cell.imageView.image = photo.thumbnail;
    
    //考虑重用的问题
    cell.selectedButton.selected = photo.isSelected;
    
    
    return cell;
    
}

#pragma mark -- MKCollectionViewCellDelegate

- (BOOL)photoCell:(MKCollectionViewCell *)cell shouldUpdateSelectedButtonState:(BOOL)isSelected{
    
    BOOL result = NO;
    
    MWPhoto *photo = _photos[cell.tag];
    
    if (isSelected) {
        
        //选中图片少于10张才允许添加
        if (_selectedPhotos.count < 9) {
            
            photo.selected = isSelected;
            
            [_selectedPhotos addObject:photo];
            
            //允许按钮改变状态
            result = YES;
        }
    }else{
        
        photo.selected = isSelected;
        
        [_selectedPhotos removeObject:photo];
        
        //允许按钮改变状态
        result = YES;
    }
    
    return result;
}

-(void)rightButtonClick{
    
    
    if ([self.delegate respondsToSelector:@selector(photoViewController:chooseImages:)]) {
        [self.delegate photoViewController:self chooseImages:_selectedPhotos];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)enumerateAssetsInAssetsCollection:(PHAssetCollection *)assetCollection original:(BOOL)original{
    
    NSLog(@"相簿名:%@",assetCollection.localizedTitle);
    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
//    // 同步获得图片,只会返回一张图片
//    options.synchronous = YES;
    
    // 获得某个相簿的所有的PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];

    for (PHAsset * asset in assets) {
        
        MWPhoto * photo = [[MWPhoto alloc] init];
        photo.URL = [NSURL URLWithString:asset.localIdentifier];
        
        //localIdentifier:图片的唯一标示
        for (MWPhoto * selectedPhoto in _lastSelectedPhotos) {
            //URL:照片的唯一标示
            if ([selectedPhoto.URL.absoluteString isEqualToString:photo.URL.absoluteString]) {
                
                photo.selected = YES;
                
                [_selectedPhotos addObject:photo];
                
                break;
            }
        }
        

        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        PHImageManager * defaultManager = [PHImageManager defaultManager];

        // 从asset中获取图片
        [defaultManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            //result为获得的图片,这里用的是原图  不是缩略图
            photo.thumbnail = result;
            [_photos addObject:photo];
        }];
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
