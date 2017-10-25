//
//  CommentsViewController.h
//  MoShouBroker
//
//  Created by Aminly on 15/6/29.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "HMActionSheet.h"
#import "DNImagePickerController.h"

@interface CommentsViewController : BaseViewController<UITextViewDelegate,DNImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{

    UITextView *_commentTV;
    UIImagePickerController *_pickerImage;
    UIButton *_addBtn;
    UILabel *_tip;
    UILabel *_fountNum;
    int _count;
    NSMutableArray *_imagesArr;
    NSMutableArray *_newImagesArr;

    NSMutableArray *_btnImagesArr;
    UIView *_blackView;
    UIButton *_deleteImageBtn;
    UIButton *_viewBtn;
    CGRect _viewFrame;
    UIView *_imagesView;
    UIImageView *_bigImage;
    UILabel *_countsLabel;
    HMActionSheet *_hmSheet;
    UIButton *okBtn;
    DNImagePickerController *_dnImagePicker;
    NSMutableArray *_newSelectedAssets;

}
@property (nonatomic,retain)UINavigationController *myNave;
@property (nonatomic,strong)NSMutableArray *assetsArray;

@property (nonatomic,strong)NSMutableArray *selectedAssets;

@end
