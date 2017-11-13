//
//  ChangeShopViewController.h
//  MoShou2
//
//  Created by Aminly on 15/12/3.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "HMActionSheet.h"

@interface ChangeShopViewController : BaseViewController<HMActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIImagePickerController *pickerImage;

@end
