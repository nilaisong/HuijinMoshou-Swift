//
//  LocalContactsViewController.m
//  MoShouBroker
//
//  Created by wangzz on 15/6/25.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "LocalContactsViewController.h"
#import "NSString+TKUtilities.h"
#import "UIImage+TKUtilities.h"
#import "ChineseToPinyin.h"
#import "ChineseString.h"
#import "CustomerOperationViewController.h"
#import "NSString+Extension.h"
#import "IQKeyboardManager.h"
#import "CustomerEmptyView.h"

@interface LocalContactsViewController ()

@property (strong, nonatomic) UITableView *tableView;//选项列表视图
@property (nonatomic, strong) NSMutableArray *addressBookTemp;//通讯录获取到的联系人集合
@property (nonatomic, strong) CustomerEmptyView *emptyView;//空白页
@property (nonatomic, strong) NSMutableArray *addressSortedArray;//根据索引存储联系人数据
@property (nonatomic, strong) NSMutableArray *firstLetterArray;//索引
@property (nonatomic, strong) NSMutableArray *searchArray;//搜索结果

@property (nonatomic, strong) UIView                 *searchShadowBgView;//输入搜索关键字时出现的背景，用来遮挡原联系人数据列表
@property (nonatomic, strong) UITextField  *searchBarTextField;
@property (nonatomic, strong) UILabel *firstLetterLabel;

@end

@implementation LocalContactsViewController
@synthesize addressBookTemp;
//@synthesize searchBarView;
@synthesize addressSortedArray;
@synthesize firstLetterArray;
@synthesize searchArray;

@synthesize searchShadowBgView;
//@synthesize searchTableView;
@synthesize searchBarTextField;
@synthesize firstLetterLabel;

- (id)init
{
    self = [super init];
    if (self) {
        addressSortedArray = [[NSMutableArray alloc] init];
        addressBookTemp = [[NSMutableArray alloc] init];
        firstLetterArray = [[NSMutableArray alloc] init];
        //获取通讯录联系人数据
        [self initAddressContact];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    利用GCD并行多个线程并且等待所有线程结束之后再执行其它任务
    //    dispatch_group_t group = dispatch_group_create();
    //    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
    //        // 并行执行的线程一
    //    });
    //    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
    //        // 并行执行的线程二
    //    });
    //    dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
    //        // 汇总结果
    //    });
    self.navigationBar.titleLabel.text = @"通讯录";
    self.view.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    searchArray = [[NSMutableArray alloc] init];
    //创建搜索框
    [self createSearchView];
    //联系人按照拼音首字母排序并分组
    [self sortDataWithSourceData:addressBookTemp];
    
    //判断联系人是否为空，是则显示空空如也图片，否则显示正常数据列表
    _emptyView = [[CustomerEmptyView alloc] initWithFrame:CGRectMake(0, viewTopY+44, kMainScreenWidth, self.view.bounds.size.height-viewTopY-44)];
    [self.view addSubview:_emptyView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY+44, kMainScreenWidth, self.view.bounds.size.height - viewTopY-44) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BACKGROUNDCOLOR;//[UIColor whiteColor];
    self.tableView.sectionIndexColor=BLUEBTBCOLOR;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    if (addressBookTemp.count>0) {
        self.emptyView.hidden = YES;
    }else
    {
        self.tableView.hidden = YES;
    }
    
    firstLetterLabel=[[UILabel alloc] init];
    CGFloat x = kMainScreenWidth*2/3-25;
    CGFloat y = self.view.bounds.size.height*2/3-50;
    firstLetterLabel.frame=CGRectMake(x, y, 50, 50);
    firstLetterLabel.backgroundColor=[UIColor colorWithHexString:@"c9c9ce" alpha:0.6];
    firstLetterLabel.textColor=[UIColor colorWithHexString:@"939393"];
    firstLetterLabel.font=[UIFont boldSystemFontOfSize:30];
    firstLetterLabel.textAlignment = NSTextAlignmentCenter;
    [firstLetterLabel.layer setMasksToBounds:YES];
    [firstLetterLabel.layer setCornerRadius:5];
    firstLetterLabel.hidden = YES;
    [self.view bringSubviewToFront:firstLetterLabel];
    [self.view addSubview:firstLetterLabel];
    
    IQKeyboardManager *mage = [IQKeyboardManager sharedManager];
    mage.enable = YES;
    mage.shouldResignOnTouchOutside = YES;
    mage.shouldToolbarUsesTextFieldTintColor = YES;
    mage.enableAutoToolbar = NO;
    // Do any additional setup after loading the view.
}
//解决热点连接状态栏或导航时纵向适配的问题
-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (self.tableView.superview) {
        self.tableView.frame =CGRectMake(0, searchBarTextField.bottom+8, self.view.bounds.size.width, self.view.bounds.size.height - searchBarTextField.bottom-8) ;
    }
}

- (void)createSearchView
{
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(10, viewTopY+7, kMainScreenWidth- 20, 30)];
    searchBarView.backgroundColor = [UIColor whiteColor];
    [searchBarView.layer setCornerRadius:5];
    [searchBarView.layer setMasksToBounds:YES];
    [self.view addSubview:searchBarView];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, searchBarView.top+8, 14, 14)];
    [searchImageView setImage:[UIImage imageNamed:@"icon_search"]];
    [self.view addSubview:searchImageView];
    
    searchBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(37, viewTopY+10, kMainScreenWidth - 47, 24)];
    searchBarTextField.delegate = self;
    searchBarTextField.returnKeyType = UIReturnKeySearch;
    searchBarTextField.placeholder = @"请输入姓名或拼音";
    [searchBarTextField setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
    searchBarTextField.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    searchBarTextField.textColor = NAVIGATIONTITLE;
    searchBarTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchBarTextField addTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:searchBarTextField];
}

- (void)leftBarButtonItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//联系人按照拼音首字母排序并分组
- (void)sortDataWithSourceData:(NSArray*)data1
{
    if (addressSortedArray.count > 0) {
        [addressSortedArray removeAllObjects];
    }
    if (firstLetterArray.count > 0) {
        [firstLetterArray removeAllObjects];
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [data1 count]; i++) {
        MoshouAddressBook *addressBook = nil;
        addressBook = (MoshouAddressBook *)[data1 objectForIndex:i];
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string = addressBook.name;
        chineseString.telNumber = addressBook.tel;
        if([self isBlankString:chineseString.string]){
            chineseString.string = @"";
        }
        if(![chineseString.string isEqualToString:@""])
        {
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *charStr=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                pinYinResult=[pinYinResult stringByAppendingString:charStr];
            }
            chineseString.pinYin = pinYinResult;
        }else
        {
            chineseString.pinYin = @"";
        }
        [array appendObject:chineseString];
    }
    //    NSLog(@"\n\n\n转换为拼音首字母后的NSString数组");
    //    for(int i=0;i<[array count];i++){
    //        ChineseString *chineseString=[array objectForIndex:i];
    //        NSLog(@"原String:%@----拼音首字母String:%@",chineseString.string,chineseString.pinYin);
    //    }
    //Step3:按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES], nil];
    [array sortUsingDescriptors:sortDescriptors];
    
    //Step3输出
    //    NSLog(@"\n\n\n按照拼音首字母后的NSString数组");
    //    for(int i=0;i<[array count];i++){
    //        ChineseString *chineseString=[array objectForIndex:i];
    //        NSLog(@"原String:%@----拼音首字母String:%@",chineseString.string,chineseString.pinYin);
    //    }
    // Step4:如果有需要，再把排序好的内容从ChineseString类中提取出来
    
    for (int i = 0; i < [array count]; i++) {
        ChineseString *str=[array objectForIndex:i];
        char p = [ChineseToPinyin sortSectionTitle:str.string];
        NSString* charStr = [[NSString alloc] initWithFormat:@"%c", p];
        if (![NSString isZimu:charStr]) {
            charStr = @"#";
        }
        if (![firstLetterArray containsObject:charStr]) {
            [firstLetterArray appendObject:charStr];
        }
    }
    if ([firstLetterArray containsObject:@"#"]) {
        [firstLetterArray removeObject:@"#"];
        [firstLetterArray appendObject:@"#"];
    }
    for (int i = 0; i < [firstLetterArray count]; i++) {
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        for (int j=0; j<array.count; j++) {
            ChineseString *str=[array objectForIndex:j];
            char p = [ChineseToPinyin sortSectionTitle:str.string];
            NSString* charStr = [[NSString alloc] initWithFormat:@"%c", p];
            if (![NSString isZimu:charStr]) {
                charStr = @"#";
            }
            MoshouAddressBook *addressBook = [[MoshouAddressBook alloc] init];
            addressBook.name = ((ChineseString*)[array objectForIndex:j]).string;
            addressBook.tel = ((ChineseString*)[array objectForIndex:j]).telNumber;
            if ([charStr isEqualToString:[firstLetterArray objectForIndex:i]]) {
                [sectionArray appendObject:addressBook];
            }
        }
        [addressSortedArray appendObject:sectionArray];
    }
}
- (void)initAddressContact
{
    //新建一个通讯录类
    //    ABAddressBookRef addressBooks = ABAddressBookCreate();
    ABAddressBookRef addressBooks=nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        addressBooks=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //        dispatch_release(sema);
    }
    //    else
    //    {
    //        addressBooks =ABAddressBookCreate();
    //    }
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    __block BOOL accessGranted = NO;
    //获取通讯录权限
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    { ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error)
                                               { // First time access has been granted, add the contact
                                                   accessGranted = granted;
                                               });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    { // The user has previously given access, add the contact
        accessGranted = YES;
    } else { // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通讯录不允许访问" message:@"您可以通过操作“设置->通用->还原->还原位置与隐私”来进行访问通讯录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        //        [alertView show];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64+44, kMainScreenWidth, self.view.bounds.size.height - 64-44)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view bringSubviewToFront:view];
        [self.view addSubview:view];
        NSString *str = @"请在iPhone的\"设置-隐私-通讯录选项\r\n中，允许魔售访问您的通讯录。\"";
        //        NSDictionary *attributes = @{NSFontAttributeName:FONT(14)};
        //        CGSize size = [str sizeWithAttributes:attributes];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, view.height/2-30, view.width-60, 40)];
        label.text = str;
        label.font = FONT(14);
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 2;
        [view addSubview:label];
    }
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取当前联系人的邮箱 注意是数组
        //        NSMutableArray * emailArr = [[NSMutableArray alloc]init];
        //        ABMultiValueRef emails= ABRecordCopyValue(person, kABPersonEmailProperty);
        //        for (NSInteger j=0; j<ABMultiValueGetCount(emails); j++) {
        //            [emailArr appendObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(emails, j))];
        //        }
        //获取当前联系人的备注
        //        NSString*notes=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonNoteProperty));
        //获取当前联系人的电话 数组
        NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
        ABMultiValueRef phones= ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
            [phoneArr appendObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
            
        }
        for (int j=0; j<phoneArr.count; j++) {
            //新建一个addressBook model类
            MoshouAddressBook *addressBook = [[MoshouAddressBook alloc] init];
            
            //获取个人名字
            CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            CFStringRef abFullName = ABRecordCopyCompositeName(person);
            
            // Save thumbnail image - performance decreasing
//            UIImage *personImage = nil;
//            if (person != nil && ABPersonHasImageData(person)) {
//                if ( &ABPersonCopyImageDataWithFormat != nil ) {
//                    // iOS >= 4.1
//                    CFDataRef contactThumbnailData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
//                    personImage = [[UIImage imageWithData:(__bridge NSData*)contactThumbnailData] thumbnailImage:CGSizeMake(44, 44)];
//                    CFRelease(contactThumbnailData);
//                    CFDataRef contactImageData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize);
//                    CFRelease(contactImageData);
//                    
//                } else {
//                    // iOS < 4.1
//                    CFDataRef contactImageData = ABPersonCopyImageData(person);
//                    personImage = [[UIImage imageWithData:(__bridge NSData*)contactImageData] thumbnailImage:CGSizeMake(44, 44)];
//                    CFRelease(contactImageData);
//                }
//            }
//            [addressBook setThumbnail:personImage];
            
            NSString *nameString = (__bridge NSString *)abName;
            NSString *lastNameString = (__bridge NSString *)abLastName;
            
            if ((__bridge id)abFullName != nil) {
                nameString = (__bridge NSString *)abFullName;
            } else {
                if ((__bridge id)abLastName != nil)
                {
                    nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                }
            }
            
            addressBook.name = nameString;
            addressBook.recordID = (int)ABRecordGetRecordID(person);;
            addressBook.rowSelected = NO;
            NSString *tel = [phoneArr objectForIndex:j];
            addressBook.tel = [tel telephoneWithReformat];
            [addressBookTemp appendObject:addressBook];
            
            if (abName) CFRelease(abName);
            if (abLastName) CFRelease(abLastName);
            if (abFullName) CFRelease(abFullName);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        //        [addressBookTemp appendObject:addressBook];
        //        [addressBook release];
        
    }
    
    if (allPeople) {
        CFRelease(allPeople);
    }
    if (addressBooks) {
        CFRelease(addressBooks);
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return firstLetterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (addressSortedArray.count > section) {
        count = ((NSArray*)[addressSortedArray objectForIndex:section]).count;
    }
    return count;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return firstLetterArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *letter = @"";
    if (firstLetterArray.count > section) {
        letter = [firstLetterArray objectForIndex:section];
    }
    return letter;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in self.firstLetterArray)
    {
        if([character isEqualToString:title])
        {
            [self showFirstLetter:title];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:count]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
            return count;
        }
        count ++;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    UIView *lineView = nil;
    //    if (cell == nil)
    //    {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCustomCellID];// autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    lineView = [self createLineView:64.5];//[[UIImageView alloc]initWithFrame:CGRectMake(0, 44 - 1, kMainScreenWidth, 1)];
    //        lineView.tag = 212;
    [cell.contentView addSubview:lineView];
    //    }
    //    else
    //    {
    //        lineView = (UIView *)[cell.contentView viewWithTag:212];
    //    }
    //    cell.backgroundColor = [UIColor clearColor];
    MoshouAddressBook *addressBook = nil;
    if (addressSortedArray.count>indexPath.section) {
        if (((NSArray*)[addressSortedArray objectForIndex:indexPath.section]).count>indexPath.row) {
            addressBook = (MoshouAddressBook *)[(NSArray*)[addressSortedArray objectForIndex:indexPath.section] objectForIndex:indexPath.row];
        }
        if (indexPath.row == ((NSArray*)[addressSortedArray objectForIndex:indexPath.section]).count-1) {
            lineView.hidden = YES;
        }
    }
    
    if ([[addressBook.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        cell.textLabel.text = addressBook.name;
        cell.textLabel.textColor = NAVIGATIONTITLE;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.detailTextLabel.text = addressBook.tel;
        cell.detailTextLabel.textColor = LABELCOLOR;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    } else {
        cell.textLabel.text = @"No Name";
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    _index = indexPath.section;
    MoshouAddressBook *addressBook = nil;
    if (addressSortedArray.count>indexPath.section) {
        if (((NSArray*)[addressSortedArray objectForIndex:indexPath.section]).count>indexPath.row) {
            addressBook = (MoshouAddressBook *)[(NSArray*)[addressSortedArray objectForIndex:indexPath.section] objectForIndex:indexPath.row];
        }
    }
//    if (_bIsCustomerList) {
//        CustomerOperationViewController *operationVC = [[CustomerOperationViewController alloc] init];
//        //        [operationVC checkPhoneWithCustName:addressBook.name withPhone:addressBook.tel];
//        operationVC.customerName = addressBook.name;
//        operationVC.phone = addressBook.tel;
//        operationVC.bIsCustomerList = YES;
//        [self.navigationController pushViewController:operationVC animated:YES];
//    }else{
        self.BsSelectBlock(_index,addressBook.name,addressBook.tel);
        if ([self.view superview]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
//    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 65;
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle=[self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle==nil) {
        return nil;
    }
    UILabel *label=[[UILabel alloc] init];
    label.frame=CGRectMake(10, 0, 25, 25);
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    //    [label.layer setMasksToBounds:YES];
    //    [label.layer setCornerRadius:5];
    label.text=sectionTitle;
    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)];
    [sectionView setBackgroundColor:BACKGROUNDCOLOR];
    [sectionView addSubview:label];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
#pragma mark - 创建线条
- (UIView *)createLineView:(CGFloat)y
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, y, kMainScreenWidth-10, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [searchBarTextField resignFirstResponder];
}
#pragma mark - Block回调传参
-(void)returnResultBlock:(ContactSelect)ablock
{
    self.BsSelectBlock = ablock;
}
#pragma mark - Search
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self textFieldDidChanged];
    return YES;
}

- (void)textFieldDidChanged
{
    if ([self stringContainsEmoji:searchBarTextField.text]) {
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
        return;
    }
    if ([self isBlankString:searchBarTextField.text]) {
        [self sortDataWithSourceData:addressBookTemp];
        [self.tableView reloadData];
        if (addressBookTemp.count>0) {
            self.emptyView.hidden = YES;
            self.tableView.hidden = NO;
        }else
        {
            self.tableView.hidden = YES;
            self.emptyView.hidden = NO;
        }
    }else
    {
        [self handleSearchForTerm:searchBarTextField.text];
        [self sortDataWithSourceData:searchArray];
        [self.tableView reloadData];
        if (searchArray.count>0) {
            self.emptyView.hidden = YES;
            self.tableView.hidden = NO;
        }else
        {
            self.tableView.hidden = YES;
            self.emptyView.hidden = NO;
        }
    }
}

-(BOOL)isChinese:(NSString*)c{
    //    int strlength = 0;
    //    char* p = (char*)[c cStringUsingEncoding:NSUnicodeStringEncoding];
    //    for (int i=0 ; i<[c lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
    //        if (*p) {
    //            p++;
    //            strlength++;
    //        }
    //        else {
    //            p++;
    //        }
    //    }
    //    return ((strlength/2)==1)?YES:NO;
    int length = (int)[c length];
    
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [c substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (cString != NULL) {
            if (strlen(cString) == 3)
            {
                NSLog(@"汉字:%s", cString);
            }else
            {
                return NO;
            }
        }else
        {
            return NO;
        }
        
    }
    
    return YES;
}

- (NSArray*)handleSearchForTerm:(NSString*)searchString
{
    if (searchArray != nil) {
        [searchArray removeAllObjects];
    }
    
    for (MoshouAddressBook *item in addressBookTemp) {
        if (![self isBlankString:searchBarTextField.text]) {
            if ([self isChinese:[searchBarTextField.text substringToIndex:1]]) {
                if ([self isChinese:[item.name substringToIndex:1]]) {
                    NSRange range1=[item.name rangeOfString:searchBarTextField.text];
                    if (range1.location!=NSNotFound) {
                        [searchArray appendObject:item];
                    }
                }else{
                    NSRange range1=[[item.name uppercaseString] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:searchBarTextField.text]];
                    if (range1.location!=NSNotFound) {
                        [searchArray appendObject:item];
                    }
                }
            }
            else{
                if ([self isChinese:[item.name substringToIndex:1]]) {
                    NSRange range1=[[ChineseToPinyin pinyinFromChiniseString:item.name]rangeOfString:[searchBarTextField.text uppercaseString]];
                    if (range1.location!=NSNotFound) {
                        [searchArray appendObject:item];
                    }
                }else{
                    NSRange range1=[[item.name uppercaseString] rangeOfString:[searchBarTextField.text uppercaseString]];
                    if (range1.location!=NSNotFound) {
                        [searchArray appendObject:item];
                    }
                }
            }
        }
    }
    return searchArray;
}

- (void)showFirstLetter:(NSString*)string
{
    firstLetterLabel.text = string;
    firstLetterLabel.hidden = NO;
    [LocalContactsViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
}

#pragma mark - 表情判断
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (void)delayMethod
{
    firstLetterLabel.hidden = YES;
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
