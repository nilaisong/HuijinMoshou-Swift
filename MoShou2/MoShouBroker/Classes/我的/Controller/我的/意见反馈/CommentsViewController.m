//
//  CommentsViewController.m
//  MoShouBroker
//
//  Created by Aminly on 15/6/29.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "CommentsViewController.h"
//#import "MyLabelView.h"
//#import "DataFactory+User.h"
#import "TipsView.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIViewExt.h"
#import "NetworkSingleton.h"
#import "UILabel+StringFrame.h"
#import "HMTool.h"
#import "DNAsset.h"
#import "Tool.h"
#import "DataFactory+User.h"
#import "UserData.h"
#import "IQKeyboardManager.h"
@interface CommentsViewController (){
    UIView *_commBgview;
}

@end

@implementation CommentsViewController
- (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

-(void)leftBarButtonItemClick
{
    
    //具体怎么返回  返回到哪自己写即可
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"意见反馈";
    self.selectedAssets = [[NSMutableArray alloc]init];
    _newSelectedAssets = [[NSMutableArray alloc]init];
    [self initLayout];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_imagesArr];
    NSUserDefaults * usd =[NSUserDefaults standardUserDefaults];
    [usd setValue:data forKey:@"selecedImageArr"];
    [usd synchronize];

    
}

-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (_bigImage.superview) {
        _bigImage.frame =    CGRectMake(0, self.view.bounds.size.height/2-(self.view.bounds.size.width/2), self.view.bounds.size.width, self.view.bounds.size.width);
    }
}

-(void)initLayout{

    _count = 0;
    _commBgview = [[UIView alloc]initWithFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, 396/2)];
    [_commBgview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_commBgview];
    
    _commentTV =[[UITextView alloc]initWithFrame:CGRectMake(25,20, kMainScreenWidth-50, 396/2-20)];
    [_commentTV setBackgroundColor:[UIColor whiteColor]];
    _commentTV.textColor = NAVIGATIONTITLE;
    [_commentTV setDelegate:self];
    _commentTV.font = [UIFont systemFontOfSize:16];
    _commentTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [_commBgview addSubview:_commentTV];
    [_commentTV becomeFirstResponder];
    _imagesView = [[UIView alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(_commBgview)+20, kMainScreenWidth, 120)];
    [self.view addSubview:_imagesView];
    
    _addBtn =[[UIButton alloc]initWithFrame:CGRectMake(25,0, 65, 65)];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-wodedingdan25"] forState:UIControlStateNormal];
    [_imagesView addSubview:_addBtn];
    [_addBtn addTarget: self action:@selector(addBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tip =[[UILabel alloc]init];
    _tip.enabled = NO;
    _tip.font = [UIFont systemFontOfSize:16];
    _tip.text = @"您的批评和建议能帮助我们更好地完善产品，请留下您的宝贵意见或者加入我们的魔售使用QQ交流群:549930431。  （300字以内）";
    _tip.textColor = TFPLEASEHOLDERCOLOR;
    [_tip autoWithFrame:CGRectMake(6,8, kMainScreenWidth-55, kFrame_Height(_commentTV)) andFontSize:15];
    [_commentTV addSubview:_tip];


    okBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-40, kFrame_Y(self.navigationBar.leftBarButton)+10,50,30)];
    [okBtn setTitle:@"发送" forState:UIControlStateNormal];
    [okBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    okBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    [okBtn addTarget:self action:@selector(uplodSuggestion:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:okBtn];
    okBtn.enabled = NO;
    [okBtn setTitleColor:LINECOLOR forState:UIControlStateNormal];

    _imagesArr = [[NSMutableArray alloc]init];
    _btnImagesArr = [[NSMutableArray alloc]init];
    _newImagesArr = [[NSMutableArray alloc]init];

}
- (void)leaveEditMode {
    [_commentTV resignFirstResponder];
}
#pragma mark 提交后刷新页面
-(void)updateLayout{

    for (UIButton *btn in [self.view subviews]) {
        if (btn.tag == 2000) {
            [btn removeFromSuperview];
        }
    }

    [_commentTV setText:@""];
    _commentTV.userInteractionEnabled = YES;
    [_countsLabel setFrame:CGRectMake(_commentTV.frame.origin.x+_commentTV.frame.size.width-86, _commentTV.frame.origin.y+_commentTV.frame.size.height,100, 30)];
    [_commentTV resignFirstResponder];
    _tip.hidden = NO;
    [_viewBtn removeFromSuperview];
    [_deleteImageBtn removeFromSuperview];
    [_btnImagesArr removeAllObjects];
    [_imagesArr removeAllObjects];
    [_imagesView removeAllSubviews];
    _addBtn =[[UIButton alloc]initWithFrame:CGRectMake(25,0, 65, 65)];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-wodedingdan25"] forState:UIControlStateNormal];
    [_imagesView addSubview:_addBtn];
    [_addBtn addTarget: self action:@selector(addBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.selected = YES;
    okBtn.userInteractionEnabled = YES;
    okBtn.enabled = NO;
    [okBtn setTitleColor:LINECOLOR forState:UIControlStateNormal];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_imagesArr];
    NSUserDefaults * usd =[NSUserDefaults standardUserDefaults];
    [usd setValue:data forKey:@"selecedImageArr"];
    [usd synchronize];
    _count = 0;

}

#pragma mark 提交按钮事件
-(void)uplodSuggestion:(UIButton *)btn {
    btn.userInteractionEnabled = NO;
    if (_commentTV.text.length>0) {
        if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
            UIImageView* loadingView = [self setRotationAnimationWithView];
//            [[AccountServiceProvider sharedInstance] submitFeedbackWithContent:[_commentTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] imgArray:_imagesArr completionClosure:^(ResponseResult * result)
//            {
//
//            }];
          
            [[DataFactory sharedDataFactory]submitCommentsWithcontent:[_commentTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] andImagesArr:_imagesArr andCallback:^(ActionResult *result) {
                if (result.success) {
                    [TipsView showTipsCantClick:@"您的意见我们已收到，感谢您的支持！" inView:self.view];
                    [self updateLayout];
                    __weak CommentsViewController *option = self;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //防止多次pop发生崩溃闪退
                        if ([self.view superview]) {
                            [option.navigationController popViewControllerAnimated:YES];
                        }
                    });
                }else{
                    [TipsView showTipsCantClick:result.message inView:self.view];
                }
                [self removeRotationAnimationView:loadingView];
            }];
        }
    }else{
        [TipsView showTips:@"请输入0-300字的建议" inView:self.view];
        btn.userInteractionEnabled = YES;
    }
}
#pragma mark 添加图片按钮事件
-(void)addBtnTouched:(UIButton *)button{
    [_commentTV resignFirstResponder];
    if (_hmSheet) {
        [_hmSheet removeFromSuperview];
    }
    _hmSheet = [[HMActionSheet alloc]initWithDelegate:self];
    [self.view addSubview:_hmSheet];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length<=0) {
        _tip.hidden = NO;
        okBtn.selected =YES;
        okBtn.userInteractionEnabled = NO;
        okBtn.enabled = NO;
        [okBtn setTitleColor:LINECOLOR forState:UIControlStateNormal];

    }else{
        _tip.hidden = YES;
        [okBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        okBtn.selected =NO;
        okBtn.enabled = YES;
        okBtn.userInteractionEnabled = YES;
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return  YES;
}
//选择完图片讲图片压缩后存到userdefult中
- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    dispatch_async(dispatch_get_main_queue(), ^{

    [_hmSheet disappear];
    UIImageView *loadingImage =[self setRotationAnimationWithView];
    self.assetsArray = [NSMutableArray arrayWithArray:imageAssets];
    if (self.assetsArray.count+_imagesArr.count<=3) {
    
        for (int i = 0; i<self.assetsArray.count; i++) {
            DNAsset *dnasset=[self.assetsArray objectForIndex:i];
            ALAssetsLibrary *lib = [self defaultAssetsLibrary];
            __weak typeof(self) weakSelf = self;
            [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset){
//                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (asset) {
                    UIImage* image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    UIButton *imageBtn =[[UIButton alloc]initWithFrame:_addBtn.frame];
                    [imageBtn setTag:2000];
                    [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
                    [_imagesView addSubview:imageBtn];
                    [imageBtn addTarget:self action:@selector(imageClickAction:) forControlEvents:UIControlEventTouchUpInside];
                    [_addBtn setFrame:CGRectMake(imageBtn.frame.origin.x+imageBtn.frame.size.width+15, imageBtn.frame.origin.y, imageBtn.frame.size.width, imageBtn.frame.size.height)];
                    
                    
                    _deleteImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [_deleteImageBtn setFrame:CGRectMake(imageBtn.frame.size.width-15, -4.5, 22, 21)];
//                    [_deleteImageBtn setBackgroundImage:[UIImage imageNamed:@"btn-deletePic@3x"] forState:UIControlStateNormal];
                    [_deleteImageBtn setTag:_count];
                    [_deleteImageBtn addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
                    UIImageView *deleteImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageBtn.frame.size.width-13, -3, 15, 15)];
                    deleteImage.image = [UIImage imageNamed:@"btn-deletePic@3x"];
                    [imageBtn addSubview:deleteImage];
                    [imageBtn addSubview:_deleteImageBtn];
//                    UIImage *im = [imageBtn backgroundImageForState:UIControlStateNormal];
                    _count ++;
                    if(_count>=3){
                        [_addBtn setHidden:YES];
                    }
                    [self.selectedAssets appendObject:asset];
                    [_imagesArr appendObject:[self changeImageWithSmallSizeWithImage:image ]];
                    [_btnImagesArr appendObject:imageBtn];
                    
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_imagesArr];
                    NSUserDefaults * usd =[NSUserDefaults standardUserDefaults];
                    [usd setValue:data forKey:@"selecedImageArr"];
                    [usd synchronize];

                } else {
                    // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                    [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                       usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                     {
                         [group enumerateAssetsWithOptions:NSEnumerationReverse
                                                usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                    
                                                    if([[result valueForProperty:ALAssetPropertyAssetURL] isEqual:dnasset.url])
                                                    {
                                                        UIImageView *selectImage =[[UIImageView alloc]initWithFrame:_addBtn.frame];
                                                        UIImage* image = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                                                        [selectImage setImage:image];
                                                        [_imagesView addSubview:selectImage];
                                                        [_addBtn setFrame:CGRectMake(selectImage.frame.origin.x+selectImage.frame.size.width+15, selectImage.frame.origin.y, selectImage.frame.size.width, selectImage.frame.size.height)];
                                                        *stop = YES;
                                                    }
                                                }];
                     }
                                     failureBlock:^(NSError *error)
                     {
                         UIImageView *selectImage =[[UIImageView alloc]initWithFrame:_addBtn.frame];
                         UIImage* image = [[UIImage alloc]init];
                         [selectImage setImage:image];
                         [_imagesView addSubview:selectImage];
                         [_addBtn setFrame:CGRectMake(selectImage.frame.origin.x+selectImage.frame.size.width+15, selectImage.frame.origin.y, selectImage.frame.size.width, selectImage.frame.size.height)];
                     }];
                }

                [self removeRotationAnimationView:loadingImage];
            } failureBlock:^(NSError *error){
                __strong typeof(weakSelf) strongSelf = weakSelf;
                UIImageView *selectImage =[[UIImageView alloc]initWithFrame:_addBtn.frame];
                UIImage* image = [[UIImage alloc]init];
                [selectImage setImage:image];
                [_imagesView addSubview:selectImage];
                [_addBtn setFrame:CGRectMake(selectImage.frame.origin.x+selectImage.frame.size.width+15, selectImage.frame.origin.y, selectImage.frame.size.width, selectImage.frame.size.height)];
            }];
            
            
        }

    }
    });
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [_hmSheet disappear];

    }];
}
//拍照后刷新页面并将图片存到userdefult中
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取媒体类型
    NSString* mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        self.myNave.navigationBarHidden = NO;
            UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
            UIButton *imageBtn =[[UIButton alloc]initWithFrame:_addBtn.frame];
            [imageBtn setTag:2000];
            [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_imagesView addSubview:imageBtn];
        [imageBtn addTarget:self action:@selector(imageClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteImageBtn setFrame:CGRectMake(imageBtn.frame.size.width-15, -4.5, 22, 21)];
        [_deleteImageBtn setTag:_count];
        
        [_deleteImageBtn addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *deleteImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageBtn.frame.size.width-13, -3, 15, 15)];
        deleteImage.image = [UIImage imageNamed:@"btn-deletePic@3x"];
        [imageBtn addSubview:deleteImage];
        [imageBtn addSubview:_deleteImageBtn];
             _count ++;
            if (_count<3) {
        
                [_addBtn setFrame:CGRectMake(imageBtn.frame.origin.x+imageBtn.frame.size.width+18, imageBtn.frame.origin.y, imageBtn.frame.size.width, imageBtn.frame.size.height)];
        
        
            }
        
            [_imagesArr appendObject:[self changeImageWithSmallSizeWithImage:image ]];
            [_btnImagesArr appendObject:imageBtn];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_imagesArr];
        NSUserDefaults * usd =[NSUserDefaults standardUserDefaults];
        [usd setValue:data forKey:@"selecedImageArr"];
        [usd synchronize];

            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
            }
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        [TipsView showTips: @"请选择图片文件" inView:self.view];
    }
    
    [_hmSheet disappear];

    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)openPicture{
    _dnImagePicker = [[DNImagePickerController alloc]init];
    _dnImagePicker.isFirst = YES;
    _dnImagePicker.filterType = DNImagePickerFilterTypePhotos;
    _dnImagePicker.imagePickerDelegate = self;
          [_dnImagePicker.navigationBar setBarTintColor:BACKGROUNDCOLOR];
        [_dnImagePicker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NAVIGATIONTITLE,UITextAttributeTextColor,nil]];//title设置白色
    [self presentViewController:_dnImagePicker animated:YES completion:nil];
}
-(void)openCamera{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
   _pickerImage = [[UIImagePickerController alloc] init];//初始化
      [_pickerImage.navigationBar setBarTintColor:BACKGROUNDCOLOR];
    _pickerImage.navigationBar.alpha = 1;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];//返回设置白色
    [_pickerImage.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NAVIGATIONTITLE,UITextAttributeTextColor,nil]];//title设置白色
    _pickerImage.delegate = self;
    _pickerImage.allowsEditing = NO;//设置可编辑
    _pickerImage.sourceType = sourceType;
    [self presentViewController:_pickerImage animated:YES completion:nil];
    
}


#pragma mark 重新设置
-(void)resetImages{
    [_imagesView removeAllSubviews];
    [_imagesArr removeAllObjects];
    for (int i = 0 ;i<_newImagesArr.count;i++) {
        UIButton *imageBtn = [[UIButton alloc]initWithFrame: CGRectMake(15+(78*i),0, 65, 65)];
        [imageBtn setTag: i];
        [imageBtn setBackgroundImage:[_newImagesArr objectForIndex:i] forState:UIControlStateNormal];
        [_imagesView addSubview:imageBtn];
        
         [imageBtn addTarget:self action:@selector(imageClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _deleteImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteImageBtn setFrame:CGRectMake(imageBtn.frame.size.width-15, -4.5, 22, 21)];
        [_deleteImageBtn setTag:i];
        [_deleteImageBtn addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *deleteImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageBtn.frame.size.width-13, -3, 15, 15)];
        deleteImage.image = [UIImage imageNamed:@"btn-deletePic@3x"];
        [imageBtn addSubview:deleteImage];
        [imageBtn addSubview:_deleteImageBtn];

        if (i == _newImagesArr.count-1&&_newImagesArr.count<3) {
            _addBtn =[[UIButton alloc]init];
            [_addBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-wodedingdan25"] forState:UIControlStateNormal];
            [_imagesView addSubview:_addBtn];
            [_addBtn addTarget: self action:@selector(addBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
             [_addBtn setFrame:CGRectMake(imageBtn.frame.origin.x+imageBtn.frame.size.width+15, imageBtn.frame.origin.y, imageBtn.frame.size.width, imageBtn.frame.size.height)];
        }
    }
    if (_newImagesArr.count<1) {
       
            _addBtn =[[UIButton alloc]init];
            [_addBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-wodedingdan25"] forState:UIControlStateNormal];
            [_imagesView addSubview:_addBtn];
            [_addBtn addTarget: self action:@selector(addBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [_addBtn setFrame:CGRectMake(25,0, 65, 65)];

    }
    [_imagesArr addObjectsFromArray:_newImagesArr];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_imagesArr];
    NSUserDefaults * usd =[NSUserDefaults standardUserDefaults];
    [usd setValue:data forKey:@"selecedImageArr"];
    [usd synchronize];
    [_newImagesArr removeAllObjects];
//    NSLog(@"reset-------------%d",_count);

}
-(void)deleteImageAction:(UIButton *)btn{
    [_imagesArr removeObjectForIndex:btn.tag];
        --_count;
    if (_newImagesArr.count>0) {
        [_newImagesArr removeAllObjects];
    }
    for (UIImage *image  in _imagesArr) {
        if (image) {
            [_newImagesArr appendObject:[self changeImageWithSmallSizeWithImage:image]];
        }
    }
    [self resetImages];
}

-(void)imageClickAction:(UIButton *)button{
    _blackView=[[UIView alloc]initWithFrame:self.view.bounds];
    [_blackView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_blackView];
    [_blackView setUserInteractionEnabled:YES];

    UIImage *image =[button backgroundImageForState:UIControlStateNormal];
    
    _viewFrame = button.frame;
    if (_bigImage) {
        
        [_bigImage removeFromSuperview];
    }
    UIScrollView *scrol =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    
    [_blackView addSubview:scrol];
    
    _bigImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth,kMainScreenWidth*(image.size.height/image.size.width))];
    if ((kMainScreenWidth*(image.size.height/image.size.width))<kMainScreenHeight) {
        
            [_bigImage setCenter:CGPointMake(kMainScreenWidth/2, kMainScreenHeight/2)];

    }
//    [_bigImage setCenter:CGPointMake(kMainScreenWidth/2, scrol.contentSize.height/2)];
//    [_bigImage setContentMode:UIViewContentModeScaleAspectFit];
        _bigImage.image = [button backgroundImageForState:UIControlStateNormal];
    [_bigImage setUserInteractionEnabled:YES];
    [scrol setContentSize:CGSizeMake(kMainScreenWidth, _bigImage.frame.size.height)];
    [scrol addSubview:_bigImage];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disapBtnClickAction)];
    [_bigImage addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disapBtnClickAction)];

    [_blackView addGestureRecognizer:tap2];
//    UIButton *disapBtn =[[UIButton alloc]initWithFrame:self.view.bounds];
//    [disapBtn addTarget:self action:@selector(disapBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:disapBtn];

}
-(void)disapBtnClickAction{
    [_bigImage removeFromSuperview];
    [_blackView removeFromSuperview];
    [_viewBtn setFrame:_viewFrame];
//    for (UIButton *deleteBtn in [_viewBtn subviews]) {
//        if (deleteBtn.tag == btn.tag) {
//            deleteBtn.hidden = NO;
//        }
//    }
//    [btn removeFromSuperview];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that c an be recreated.
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.myNave = navigationController;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >= 300)
    {
        textView.text = [textView.text substringToIndex:300];
        [TipsView showTips:@"最多输入300字" inView:self.view];
        [textView resignFirstResponder];
    }
    [_countsLabel setFrame:CGRectMake(_commentTV.frame.origin.x+_commentTV.frame.size.width-40, _commentTV.frame.origin.y+_commentTV.frame.size.height,80, 30)];
    [_countsLabel setText:[NSString stringWithFormat:@"%ld/300",(unsigned long)textView.text.length]];
    if (textView.text.length>0) {
        okBtn.selected = NO;
        _tip.hidden = YES;
        okBtn.enabled = YES;
        [okBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];

        okBtn.userInteractionEnabled = YES;
    }else{
        okBtn.enabled = NO;
        _tip.hidden = NO;
        okBtn.selected = YES;
        [okBtn setTitleColor:LINECOLOR forState:UIControlStateNormal];
        okBtn.userInteractionEnabled = NO;
    }
}

-(void)firstBtnClickAction{
    [self openCamera];
}
-(void)seconBtnClickAction{
    [self openPicture];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_hmSheet disappear];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//图片压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
-(UIImage*)changeImageWithSmallSizeWithImage:(UIImage *)image{
    float kCompressionQuality = 0.3;
    NSData *photo = UIImageJPEGRepresentation(image, kCompressionQuality);
    UIImage *changedImage =[UIImage imageWithData:photo];
    return changedImage;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    mage.enable = NO;
    mage.shouldResignOnTouchOutside = NO;
    mage.shouldToolbarUsesTextFieldTintColor = NO;
    mage.enableAutoToolbar = NO;
    
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
