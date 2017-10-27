//
//  ChangeShopViewController.m
//  MoShou2
//
//  Created by Aminly on 15/12/3.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "ChangeShopViewController.h"
#import "HMTool.h"
#import "UILabel+StringFrame.h"
#import "UserData.h"
#import "DataFactory+User.h"
@interface ChangeShopViewController (){

    HMActionSheet *_actionSheet;
    UIButton *_addbtn;
    UIButton *_saveBtn;
    UITextField *_shopStrTF;
    //add by wangzz 160801
    UILabel *bottomTip;
    UITextField *numberTextF;
    //end
    BOOL _isClicked;
}

@end

@implementation ChangeShopViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    //add by wangzz 160801
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    //end
}
-(void)initUI{

    self.navigationBar.titleLabel.text = @"修改门店";
    [self.view setBackgroundColor:BACKGROUNDCOLOR];//[UIColor whiteColor]
    _saveBtn =[[UIButton alloc]init];
    [_saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:POINTMALLGRAYLABELCOLOR forState:UIControlStateDisabled];
    [_saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    _saveBtn.enabled = NO;
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_saveBtn setFrame:CGRectMake(kMainScreenWidth-16-50, kFrame_Y(self.navigationBar.leftBarButton)+10, 60, 30)];
    [self.navigationBar addSubview:_saveBtn];
    [_saveBtn addTarget: self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    //add by wangzz 160801
    UIView *blueBgView = [[UIView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, 0)];
    blueBgView.backgroundColor = BLUEBTBCOLOR;
    [self.view addSubview:blueBgView];
    //end
    
    UILabel *tip =[[UILabel alloc]init];
    NSString *shopName = [UserData sharedUserData].userInfo.storeName;
    [tip setText:[NSString stringWithFormat:@"当前绑定门店为: %@",shopName]];
    CGSize tipSiz = [self textSize:tip.text withConstraintWidth:kMainScreenWidth - 32];
//    CGSize tipSiz =[HMTool getTextSizeWithText:tip.text andFontSize:14];
    [tip setTextColor:[UIColor whiteColor]];//TFPLEASEHOLDERCOLOR
    [tip setFont:[UIFont systemFontOfSize:14]];
    [tip setFrame:CGRectMake(16, 16, kMainScreenWidth-32, tipSiz.height)];//kFrame_YHeight(self.navigationBar)+
    //add by wangzz 160729
    tip.textAlignment = NSTextAlignmentCenter;
    [tip setLineBreakMode:NSLineBreakByWordWrapping];
    tip.numberOfLines = 0;
    [blueBgView addSubview:tip];
    //end
//    [self.view addSubview:tip];
    CGFloat tipHeight = tip.bottom+16;
    if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum]) {
        [tip setHidden:YES];
        tipHeight = 16;
    }
    //modify by wangzz 160801
    NSDictionary *attributes = @{NSFontAttributeName:FONT(14)};
    CGSize size = [@"门店唯一码:" sizeWithAttributes:attributes];
    UILabel *shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, tipHeight+5, size.width, 30)];
    shopLabel.text = @"门店唯一码:";
    shopLabel.textColor = [UIColor whiteColor];
    shopLabel.font = FONT(14);
    [blueBgView addSubview:shopLabel];
    
    UIView *shopBgView = [[UIView alloc] initWithFrame:CGRectMake(shopLabel.right+10, tipHeight, blueBgView.width-16-10-shopLabel.right, 40)];
    shopBgView.backgroundColor = [UIColor whiteColor];
    [shopBgView.layer setCornerRadius:4];
    [shopBgView.layer setMasksToBounds:YES];
    [blueBgView addSubview:shopBgView];
    
    _shopStrTF=[[UITextField alloc]initWithFrame:CGRectMake(shopBgView.left+10, shopLabel.top, shopBgView.width-20, 30)];
    _shopStrTF.delegate = self;
    _shopStrTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _shopStrTF.backgroundColor = [UIColor whiteColor];
    [_shopStrTF setPlaceholder:@"请输所在入门店唯一码"];
    _shopStrTF.font =[UIFont systemFontOfSize:16];
    _shopStrTF.textColor = NAVIGATIONTITLE;
//    [_shopStrTF setFrame:CGRectMake(16, kFrame_YHeight(tip)+20, self.view.bounds.size.height-32, 30)];
    [blueBgView addSubview:_shopStrTF];
    if (![self isBlankString:[UserData sharedUserData].userInfo.storeNum]) {
        _shopStrTF.text =[UserData sharedUserData].userInfo.storeNum;//_shopStrTF.placeholder =[UserData sharedUserData].storeNum;
    }
    [_shopStrTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //员工编号
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, shopBgView.bottom+16+5, size.width, 30)];
    numberLabel.text = @"员工编号:";
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = FONT(14);
    [blueBgView addSubview:numberLabel];
    
    UIView *numberBgView = [[UIView alloc] initWithFrame:CGRectMake(numberLabel.right+10, shopBgView.bottom+16, blueBgView.width-16-10-shopLabel.right, 40)];
    numberBgView.backgroundColor = [UIColor whiteColor];
    [numberBgView.layer setCornerRadius:4];
    [numberBgView.layer setMasksToBounds:YES];
    [blueBgView addSubview:numberBgView];
    
    numberTextF =[[UITextField alloc]initWithFrame:CGRectMake(numberBgView.left+10, numberLabel.top, numberBgView.width-20, 30)];
    numberTextF.delegate = self;
    numberTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberTextF.backgroundColor = [UIColor whiteColor];
    [numberTextF setPlaceholder:@"请输入你的员工编号"];
    numberTextF.font =[UIFont systemFontOfSize:16];
    numberTextF.textColor = NAVIGATIONTITLE;
    [numberTextF addTarget:self action:@selector(numberTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [blueBgView addSubview:numberTextF];
    if (![self isBlankString:[UserData sharedUserData].userInfo.employeeNo]) {
        numberTextF.text =[UserData sharedUserData].userInfo.employeeNo;
    }
    
    blueBgView.height = numberBgView.bottom +16;

//    UIView *line =[HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(_shopStrTF), kMainScreenWidth, 0.5) andColor:LINECOLOR];
//    [self.view addSubview:line];
    
    _addbtn =[[UIButton alloc]initWithFrame:CGRectMake(60.0/750*kMainScreenWidth, blueBgView.bottom+20, kMainScreenWidth*(1-2*60.0/750), kMainScreenWidth*(1-2*60.0/750)*141.0/638)];//CGRectMake(kMainScreenWidth/2-(kMainScreenWidth-55)/2, blueBgView.bottom+35, kMainScreenWidth-55, kMainScreenWidth-55)
    [_addbtn setBackgroundImage:[UIImage imageNamed:@"iconfont-tianjiatupian"] forState:UIControlStateNormal];
    [_addbtn setTitle:@"添加名片或相关图片" forState:UIControlStateNormal];
    [_addbtn setTitleColor:TFPLEASEHOLDERCOLOR forState:UIControlStateNormal];
    [_addbtn.titleLabel setFont:FONT(14)];
    [_addbtn addTarget:self action:@selector(popActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addbtn];
    
    bottomTip =[[UILabel alloc]init];
    [bottomTip setText:@"1、请提交要绑定门店的唯一码/员工编号，审核通过后可绑定到新门店（信息会保留），审核需要1-2个工作日。\r\n2、建议在绑定门店和修改门店时提交图片。"];
    [bottomTip autoWithFrame:CGRectMake(16, kFrame_YHeight(_addbtn)+16, kMainScreenWidth-32, 0) andFontSize:12];//self.view.bounds.size.height-(kFrame_YHeight(_addbtn)+35)
    [bottomTip setTextColor:TFPLEASEHOLDERCOLOR];
    [self.view addSubview:bottomTip];
    //end
}

- (void)handleTapGesture:(UITapGestureRecognizer*)gesture
{
    [self.view endEditing:YES];
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    CGSize result;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGFloat width = contraintWidth;
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        result = size;
        result.width = ceilf(result.width);
        result.height = ceilf(result.height);
    }
    else
    {
        result = [text sizeWithFont: font constrainedToSize: constraint];
    }
    return result;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length>0) {
        _saveBtn.enabled = YES;
    }else{
        _saveBtn.enabled = NO;

    }
}

- (void)numberTextFieldDidChange:(UITextField*)textField
{
//    if ([UserData sharedUserData].limitEmployeeNo) {
//        if (textField.text.length>0) {
//            _saveBtn.enabled = YES;
//        }else{
//            _saveBtn.enabled = NO;
//            
//        }
//    }else
//    {
        _saveBtn.enabled = YES;
//    }
    if (numberTextF.text.length >= 18) {
        numberTextF.text = [numberTextF.text substringToIndex:18];
        [numberTextF resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    return [textField resignFirstResponder];
}
#pragma  mark 保存action
-(void)saveAction{
    _saveBtn.userInteractionEnabled = NO;
    [_shopStrTF resignFirstResponder];

    if (_shopStrTF.text.length<=0) {
        [TipsView showTips:@"请输入门店码" inView:self.view];
        _saveBtn.userInteractionEnabled = YES;
    }else if (_shopStrTF.text.length>0&&[_shopStrTF.text isEqualToString:[UserData sharedUserData].userInfo.storeNum]){
        NSString *employee = [UserData sharedUserData].userInfo.employeeNo;
        if ((numberTextF.text.length>0 && [numberTextF.text isEqualToString:employee]) || (numberTextF.text.length==0 && [self isBlankString:employee])) {
            [TipsView showTips:@"你没有进行任何修改。" inView:self.view];
            _saveBtn.userInteractionEnabled = YES;
        }else
        {
            if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
                UIImageView *loading =[self setRotationAnimationWithView];
                [[DataFactory sharedDataFactory]changEmpoyeeNo:numberTextF.text andCallback:^(ActionResult *result) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        if (result.success ) {
                            [self removeRotationAnimationView:loading];
                            [TipsView showTips:result.message inView:self.view];
                            [_addbtn setEnabled:NO];
                            _shopStrTF.enabled = NO;
                            numberTextF.enabled = NO;
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHPERSONSHOP" object:self];
//                            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINETABLEVIEW" object:self];
                            
                            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackAction) userInfo:nil repeats:NO];
                            
                        }else{
                            [self removeRotationAnimationView:loading];
                            
                            [TipsView showTips:result.message inView:self.view];
                        }
                    });
                    
                }];
                _saveBtn.userInteractionEnabled = YES;
            }
        }

    }else if (_shopStrTF.text.length>0&&![_shopStrTF.text isEqualToString:[UserData sharedUserData].userInfo.storeNum]) {
       
        
        if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
            UIImageView *loading =[self setRotationAnimationWithView];
            [[DataFactory sharedDataFactory]changShopCode:_shopStrTF.text withEmpoyeeNo:numberTextF.text andShopPic:(_isClicked?[_addbtn backgroundImageForState:UIControlStateNormal] :nil) andCallback:^(ActionResult *result) {
                dispatch_async(dispatch_get_main_queue(),^{

                if (result.success ) {
                    [self removeRotationAnimationView:loading];
                    [TipsView showTips:result.message inView:self.view];
                    [_addbtn setEnabled:NO];
                    _shopStrTF.enabled = NO;
                    numberTextF.enabled = NO;
                    [UserData sharedUserData].chooseCityName = @"";
                    [UserData sharedUserData].chooseCityId = @"";
                    if ([ self isBlankString:[UserData sharedUserData].userInfo.storeNum]) {
                        [UserData sharedUserData].userInfo.storeNum =_shopStrTF.text ;
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHPERSONSHOP" object:self];
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINETABLEVIEW" object:self];
                    //add by wangzz 2016-4-5
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCustomer" object:self];
                    //end

                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackAction) userInfo:nil repeats:NO];
            
                }else{
                    [self removeRotationAnimationView:loading];

                    [TipsView showTips:result.message inView:self.view];
                }
                });
               
            }];
            _saveBtn.userInteractionEnabled = YES;

        }

    }
}
-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popActionSheet:(UIButton *)button{
    [_shopStrTF resignFirstResponder];
    if (_actionSheet) {
        [_actionSheet removeFromSuperview];
    }
    _actionSheet = [[HMActionSheet alloc]initWithDelegate:self];
    [self.view addSubview:_actionSheet];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    _isClicked = NO;
    [self.pickerImage dismissViewControllerAnimated:YES completion:nil];
    [_actionSheet disappear];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    _isClicked = YES;
    //获取媒体类型
    NSString* mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        
        UIImage *image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
       
        _addbtn.width = MIN(kMainScreenWidth*(1-2*60.0/750), kMainScreenHeight-_addbtn.top-bottomTip.height-16-5);
        _addbtn.height = _addbtn.width;
        _addbtn.centerX = kMainScreenWidth/2;
        [_addbtn setTitle:@"" forState:UIControlStateNormal];
        bottomTip.top = _addbtn.bottom+16;
        
        [_addbtn setBackgroundImage:image forState:UIControlStateNormal];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
        }
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        [TipsView showTips: @"请选择图片文件" inView:self.view];
    }
    [_actionSheet disappear];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)openPicture{
    self.pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.pickerImage.sourceType];
        
    }
    [self.pickerImage.navigationBar setBarTintColor:BACKGROUNDCOLOR];
    self.pickerImage.navigationBar.alpha = 1;
    [self.pickerImage.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NAVIGATIONTITLE,UITextAttributeTextColor,nil]];//title设置白色
    
    self.pickerImage.delegate = self;
    self.pickerImage.allowsEditing = YES;
    [self presentViewController:self.pickerImage animated:YES completion:nil];
}
-(void)openCamera{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    self.pickerImage = [[UIImagePickerController alloc] init];//初始化
    //    [self.pickerImage.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#f4595b"]];
    [self.pickerImage.navigationBar setBarTintColor:BACKGROUNDCOLOR];
    self.pickerImage.navigationBar.alpha = 1;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];//返回设置白色
    [self.pickerImage.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NAVIGATIONTITLE,UITextAttributeTextColor,nil]];//title设置白色
    self.pickerImage.delegate = self;
    self.pickerImage.allowsEditing = YES;//设置可编辑
    self.pickerImage.sourceType = sourceType;
    [self presentViewController:self.pickerImage animated:YES completion:nil];
    
}


-(void)firstBtnClickAction{

    [self openCamera];
    
}
-(void)seconBtnClickAction{
    [self openPicture];


}
////判断字符串是否纯中文
-(BOOL)isChinese:(NSString*)str{
    
    for (int i=0; i<str.length;i++){
        
        NSRange range=NSMakeRange(i,1);
        
        NSString *subString=[str substringWithRange:range];
        
        const char *cString=[subString UTF8String];
        
        if (strlen(cString)==3){
            
            
            if(str.length<2||str.length>15){
                
                
                return NO;
                
            }
            return YES;
            
            
        }
    }
    
    return NO;
    
    
    
}
-(BOOL)adjusStrHasNumber:(NSString *)str{
    
    if(([str rangeOfString:@"0"].location !=NSNotFound)||([str rangeOfString:@"1"].location !=NSNotFound)||([str rangeOfString:@"2"].location !=NSNotFound)||([str rangeOfString:@"3"].location !=NSNotFound)||([str rangeOfString:@"4"].location !=NSNotFound)||([str rangeOfString:@"5"].location !=NSNotFound)||([str rangeOfString:@"6"].location !=NSNotFound)||([str rangeOfString:@"7"].location !=NSNotFound)||([str rangeOfString:@"8"].location !=NSNotFound)||([str rangeOfString:@"9"].location !=NSNotFound)){
        return true;
        
    }
    return false;
}
///**
// *  test test
// */
//-(void)leftBarButtonItemClick{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHPERSONSHOP" object:self];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackAction) userInfo:nil repeats:NO];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)adjustFrameForHotSpotChange
//{
//    [super adjustFrameForHotSpotChange];
//    if (_scrollView.superview) {
//        _scrollView.frame =CGRectMake(0, kFrame_YHeight(self.navigationBar), self.view.bounds.size.width, self.view.bounds.size.height-(_headView.frame.origin.y+ _headView.frame.size.height));
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
