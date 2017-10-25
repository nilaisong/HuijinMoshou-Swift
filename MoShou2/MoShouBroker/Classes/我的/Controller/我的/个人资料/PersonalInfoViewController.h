//
//  PersonalInfoViewController.h
//  MoShouBroker
//
//  Created by Aminly on 15/6/17.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "RSKImageCropViewController.h"
#import "MyImageView.h"
#import "HMActionSheet.h"
#import "MyImageView.h"
@interface PersonalInfoViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,RSKImageCropViewControllerDelegate,UIGestureRecognizerDelegate,HMActionSheetDelegate>{

    UITableView *_headTable;
    UITableView *_infoTable;
    UITableView *_cityTable;
    UIButton *_headBtn;
    UIButton *_chengeBtn;
    UIButton *_chengePassBtn;
    CGRect _headFrame;
    NSArray *_textArr;
    UIView *_review;
    UIView *_nameMobileView;
    UIView *_cityBelongView;

    UIButton *_closeBtn;
    UIButton *_logOutBtn;
    UIImagePickerController *_pickerImage;
    MyImageView *_headImage;
    HMActionSheet *_hmSheet;

}

@property (nonatomic,retain)UINavigationController *myNave;

enum BUTTON_TAG{
    
    HEAD_BUTTON_TAG = 1000,
    PASS_BUTTON_TAG
};
-(CGSize )getTextSizeWithText:(NSString *)text andFountSize:(float)size;

@end
