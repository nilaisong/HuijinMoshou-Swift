//
//  DNAlbumTableViewController.m
//  ImagePicker
//
//  Created by DingXiao on 15/2/10.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>

#import "DNAlbumTableViewController.h"
#import "DNImagePickerController.h"
#import "DNImageFlowViewController.h"
#import "UIViewController+DNImagePicker.h"
#import "DNUnAuthorizedTipsView.h"
#import "DNSendButton.h"
#import "DNAssetsViewCell.h"
#import "DNPhotoBrowser.h"
#import "DNAsset.h"
#import "NSURL+DNIMagePickerUrlEqual.h"
static NSString* const dnalbumTableViewCellReuseIdentifier = @"dnalbumTableViewCellReuseIdentifier";
static NSUInteger const kDNImageFlowMaxSeletedNumber = 3;

@interface DNAlbumTableViewController ()<DNPhotoBrowserDelegate,DNAssetsViewCellDelegate>{
UIBarButtonItem *item1;
}
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSArray *groupTypes;
@property (nonatomic, strong) DNSendButton *sendButton;
@property (nonatomic, strong) NSURL *assetsGroupURL;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, assign) BOOL isFullImage;

#pragma mark - dataSources
@property (nonatomic, strong) NSArray *assetsGroups;
@end

@implementation DNAlbumTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
    [self loadData];
   }


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if (![self dnImagePickerController].isFirst) {
        
        self.navigationController.toolbarHidden = NO;
        self.sendButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[self dnImagePickerController].selectedArr.count];
        if ([self dnImagePickerController].selectedArr.count>0) {
            self.navigationController.toolbarItems.firstObject.enabled = YES;
            item1.enabled = YES;
            self.sendButton.sendButton.enabled = YES;
        }else{
            item1.enabled = NO;
            self.sendButton.sendButton.enabled = NO;
        }
    }
    if ([self dnImagePickerController].selectedArr.count <=0) {
        UIBarButtonItem *firstItem = self.toolbarItems.firstObject;
        firstItem.enabled = NO;
        self.sendButton.sendButton.enabled = NO;

    }else{
        UIBarButtonItem *firstItem = self.toolbarItems.firstObject;
        firstItem.enabled = YES;
        self.sendButton.sendButton.enabled = YES;

    }


}

-(void)showFirstAlbum{
    ALAssetsGroup *group = self.assetsGroups[0];
            NSURL *url = [group valueForProperty:ALAssetsGroupPropertyURL];
            if ([self dnImagePickerController].selectedArr.count>0) {
                DNImageFlowViewController *imageFlowViewController = [[DNImageFlowViewController alloc] initWithGroupURL:url andSelectedArr:[self dnImagePickerController].selectedArr];
                [self.navigationController pushViewController:imageFlowViewController animated:NO];
    
            }else{
                DNImageFlowViewController *imageFlowViewController = [[DNImageFlowViewController alloc] initWithGroupURL:url];
                [self.navigationController pushViewController:imageFlowViewController animated:NO];
                
            }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mark setup Data and View
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [self loadAssetsGroupsWithTypes:self.groupTypes completion:^(NSArray *groupAssets)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         strongSelf.assetsGroups = groupAssets;
         [strongSelf.tableView reloadData];
         if (strongSelf.assetsGroups.count<=0) {
                 [TipsView showTips:@"您的相册里面没有照片,请取消" inView:self.view];
                     }else{
             if ([strongSelf dnImagePickerController].isFirst) {
                 [strongSelf performSelector:@selector(showFirstAlbum) withObject:nil afterDelay:0.2];
             }
         }
        

     }];
    
}

- (void)setupData
{
    self.groupTypes = @[@(ALAssetsGroupAll)];
    self.assetsGroups  = [NSMutableArray new];
}

- (void)setupView
{
    self.title = NSLocalizedStringFromTable(@"albumTitle", @"DNImagePicker", @"photos");
    [self createBarButtonItemAtPosition:DNImagePickerNavigationBarPositionRight
                                   text:NSLocalizedStringFromTable(@"cancel", @"DNImagePicker", @"取消")
                                 action:@selector(cancelAction:)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:dnalbumTableViewCellReuseIdentifier];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = view;
    item1 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"preview", @"DNImagePicker", @"预览") style:UIBarButtonItemStylePlain target:self action:@selector(previewAction)];
    [item1 setTintColor:[UIColor blackColor]];
    [item1 setEnabled:NO];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
    
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item4.width = -10;
    self.sendButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[self dnImagePickerController].selectedArr.count];
    if ([self dnImagePickerController].selectedArr.count>0) {
        item1.enabled = YES;
        
    }else{
        self.sendButton.sendButton.enabled = NO;
    }
    [self setToolbarItems:@[item1,item2,item3,item4] animated:NO];
    self.navigationController.toolbarHidden = NO;
    [self.view bringSubviewToFront:self.navigationController.toolbar];

}


#pragma mark - ui actions
- (void)cancelAction:(id)sender
{
    DNImagePickerController *navController = [self dnImagePickerController];
    if (navController && [navController.imagePickerDelegate respondsToSelector:@selector(dnImagePickerControllerDidCancel:)]) {
        [navController.imagePickerDelegate dnImagePickerControllerDidCancel:navController];
    }
}
- (void)cancelAction
{
    DNImagePickerController *navController = [self dnImagePickerController];
    if (navController && [navController.imagePickerDelegate respondsToSelector:@selector(dnImagePickerControllerDidCancel:)]) {
        [navController.imagePickerDelegate dnImagePickerControllerDidCancel:navController];
    }
}
#pragma mark - getter/setter
//- (ALAssetsLibrary *)assetsLibrary
//{
//    if (nil == _assetsLibrary) {
//        _assetsLibrary = [[ALAssetsLibrary alloc] init];
//    }
//    return _assetsLibrary;
//}
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
- (DNImagePickerController *)dnImagePickerController
{
    
    if (nil == self.navigationController
        ||
        ![self.navigationController isKindOfClass:[DNImagePickerController class]])
    {
        NSAssert(false, @"check the navigation controller");
    }
    return (DNImagePickerController *)self.navigationController;
}

- (NSAttributedString *)albumTitle:(ALAssetsGroup *)assetsGroup
{
    NSString *albumTitle = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    NSString *numberString = [NSString stringWithFormat:@"  (%@)",@(assetsGroup.numberOfAssets)];
    NSString *cellTitleString = [NSString stringWithFormat:@"%@%@",albumTitle,numberString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cellTitleString];
    [attributedString setAttributes: @{
                                       NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                       NSForegroundColorAttributeName : [UIColor blackColor],
                                       }
                              range:NSMakeRange(0, albumTitle.length)];
    [attributedString setAttributes:@{
                                      NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                      NSForegroundColorAttributeName : [UIColor grayColor],
                                      } range:NSMakeRange(albumTitle.length, numberString.length)];
    return attributedString;
    
}

- (void)showUnAuthorizedTipsView
{
    DNUnAuthorizedTipsView *view  = [[DNUnAuthorizedTipsView alloc] initWithFrame:self.tableView.frame];
    self.tableView.backgroundView = view;
//    [self.tableView addSubview:view];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dnalbumTableViewCellReuseIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ALAssetsGroup *group = self.assetsGroups[indexPath.row];
    cell.textLabel.attributedText = [self albumTitle:group];
    
    //choose the latest pic as poster image
    __weak UITableViewCell *blockCell = cell;
    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:group.numberOfAssets-1] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            *stop = YES;
            blockCell.imageView.image = [UIImage imageWithCGImage:result.thumbnail];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *group = self.assetsGroups[indexPath.row];
    NSURL *url = [group valueForProperty:ALAssetsGroupPropertyURL];
    if ([self dnImagePickerController].selectedArr.count>0) {
         DNImageFlowViewController *imageFlowViewController = [[DNImageFlowViewController alloc] initWithGroupURL:url andSelectedArr:[self dnImagePickerController].selectedArr];
        [self.navigationController pushViewController:imageFlowViewController animated:YES];

    }else{
    DNImageFlowViewController *imageFlowViewController = [[DNImageFlowViewController alloc] initWithGroupURL:url];
        [self.navigationController pushViewController:imageFlowViewController animated:YES];

    }
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - get assetGroups
- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    
    for (NSNumber *type in types) {
        __weak typeof(self) weakSelf = self;
        weakSelf.assetsLibrary =[weakSelf defaultAssetsLibrary];
        [weakSelf.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue]
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop)
         {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             if (assetsGroup) {
                 // Filter the assets group
                 [assetsGroup setAssetsFilter:ALAssetsFilterFromDNImagePickerControllerFilterType([[strongSelf dnImagePickerController] filterType])];
                 // Add assets group
                 if (assetsGroup.numberOfAssets > 0) {
                     // Add assets group
                     [assetsGroups addObject:assetsGroup];
                 }
             } else {
                 numberOfFinishedTypes++;
             }
             
             // Check if the loading finished
             if (numberOfFinishedTypes == types.count) {
                 //sort
                 NSArray *sortedAssetsGroups = [assetsGroups sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                     
                     ALAssetsGroup *a = obj1;
                     ALAssetsGroup *b = obj2;
                     
                     NSNumber *apropertyType = [a valueForProperty:ALAssetsGroupPropertyType];
                     NSNumber *bpropertyType = [b valueForProperty:ALAssetsGroupPropertyType];
                     if ([apropertyType compare:bpropertyType] == NSOrderedAscending)
                     {
                         return NSOrderedDescending;
                     }
                     return NSOrderedSame;
                 }];
                 
                 // Call completion block
                 if (completion) {
                     completion(sortedAssetsGroups);
                 }
             }
         } failureBlock:^(NSError *error) {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             if ([ALAssetsLibrary authorizationStatus] != ALAuthorizationStatusAuthorized){
                 [strongSelf showUnAuthorizedTipsView];
             }
         }];
    }
}
- (void)sendButtonAction:(id)sender
{
    if ([self dnImagePickerController].selectedArr.count > 0) {
        [self sendImages];
    }
}

- (void)previewAction
{
    [self browserPhotoAsstes:[NSArray arrayWithArray:[self dnImagePickerController].selectedArr] pageIndex:0];
}


#pragma mark - DNAssetsViewCellDelegate
- (void)didSelectItemAssetsViewCell:(DNAssetsViewCell *)assetsCell
{
    assetsCell.isSelected = [self seletedAssets:assetsCell.asset];
    
    
}


#pragma mark - DNPhotoBrowserDelegate
- (void)sendImagesFromPhotobrowser:(DNPhotoBrowser *)photoBrowser currentAsset:(ALAsset *)asset
{
    if ([self dnImagePickerController].selectedArr.count <= 0) {
        [self seletedAssets:asset];
//        [self.imageFlowCollectionView reloadData];
    }
    [self sendImages];
}

- (NSUInteger)seletedPhotosNumberInPhotoBrowser:(DNPhotoBrowser *)photoBrowser
{
    return [self dnImagePickerController].selectedArr.count;
}

- (BOOL)photoBrowser:(DNPhotoBrowser *)photoBrowser currentPhotoAssetIsSeleted:(ALAsset *)asset{
    return [self assetIsSelected:asset];
}

- (BOOL)photoBrowser:(DNPhotoBrowser *)photoBrowser seletedAsset:(ALAsset *)asset
{
    BOOL seleted = [self seletedAssets:asset];
//    [self.imageFlowCollectionView reloadData];
    return seleted;
}

- (void)photoBrowser:(DNPhotoBrowser *)photoBrowser deseletedAsset:(ALAsset *)asset
{
    [self deseletedAssets:asset];
//    [self.imageFlowCollectionView reloadData];
}

- (void)photoBrowser:(DNPhotoBrowser *)photoBrowser seleteFullImage:(BOOL)fullImage
{
    self.isFullImage = fullImage;
}
- (void)sendImages
{
    NSString *properyID = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
    [[NSUserDefaults standardUserDefaults] setObject:properyID forKey:kDNImagePickerStoredGroupKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DNImagePickerController *imagePicker = [self dnImagePickerController];
    if (imagePicker && [imagePicker.imagePickerDelegate respondsToSelector:@selector(dnImagePickerController:sendImages:isFullImage:)]) {
        [imagePicker.imagePickerDelegate dnImagePickerController:imagePicker sendImages:[self seletedDNAssetArray] isFullImage:self.isFullImage];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (DNAsset *)dnassetFromALAsset:(ALAsset *)ALAsset
{
    DNAsset *asset = [[DNAsset alloc] init];
    asset.url = [ALAsset valueForProperty:ALAssetPropertyAssetURL];
    return asset;
}
- (NSArray *)seletedDNAssetArray
{
    NSMutableArray *seletedArray = [NSMutableArray new];
    for (ALAsset *asset in [self dnImagePickerController].selectedArr) {
        DNAsset *dnasset = [self dnassetFromALAsset:asset];
        [seletedArray addObject:dnasset];
    }
    return seletedArray;
}

- (void)browserPhotoAsstes:(NSArray *)assets pageIndex:(NSInteger)page
{
    DNPhotoBrowser *browser = [[DNPhotoBrowser alloc] initWithPhotos:assets
                                                        currentIndex:page
                                                           fullImage:self.isFullImage];
    browser.delegate = self;
    browser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browser animated:YES];
}
- (BOOL)seletedAssets:(ALAsset *)asset
{
    if ([self assetIsSelected:asset]) {
        return NO;
    }
    UIBarButtonItem *firstItem = self.toolbarItems.firstObject;
    firstItem.enabled = YES;
    if ([self dnImagePickerController].selectedArr.count >= kDNImageFlowMaxSeletedNumber) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"alertTitle", @"DNImagePicker", nil) message:NSLocalizedStringFromTable(@"alertContent", @"DNImagePicker", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"alertButton", @"DNImagePicker", nil) otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }else
    {
        
        [self addAssetsObject:asset];
        self.sendButton.badgeValue =[NSString stringWithFormat:@"%lu",(unsigned long)[self dnImagePickerController].selectedArr.count];
        //[NSString stringWithFormat:@"%lu",[(unsigned long)[self dnImagePickerController].selectedArr.count];
        return YES;
    }
}
- (BOOL)assetIsSelected:(ALAsset *)targetAsset
{
    for (ALAsset *asset in [self dnImagePickerController].selectedArr) {
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        NSURL *targetAssetURL = [targetAsset valueForProperty:ALAssetPropertyAssetURL];
        if ([assetURL isEqualToOther:targetAssetURL]) {
            return YES;
        }
    }
    
    return NO;
}
- (void)deseletedAssets:(ALAsset *)asset
{
    [self removeAssetsObject:asset];
    
    self.sendButton.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[self dnImagePickerController].selectedArr.count];
    
    if ([self dnImagePickerController].selectedArr.count <=0) {
        UIBarButtonItem *firstItem = self.toolbarItems.firstObject;
        firstItem.enabled = NO;
    }else{
        UIBarButtonItem *firstItem = self.toolbarItems.firstObject;
        firstItem.enabled = YES;

    }
}
- (void)removeAssetsObject:(ALAsset *)asset
{
    if ([self assetIsSelected:asset]) {
        for (int i =0; i<[self dnImagePickerController].selectedArr.count; i++) {
            ALAsset *aa =[[self dnImagePickerController].selectedArr objectAtIndex:i];
            
            if ([[[[asset defaultRepresentation]url]debugDescription] isEqualToString:[[[aa defaultRepresentation]url]debugDescription]]) {
                [[self dnImagePickerController].selectedArr removeObjectAtIndex:i];
            }
        }
    }
}
- (void)addAssetsObject:(ALAsset *)asset
{
    
    [[self dnImagePickerController].selectedArr addObject:asset];
    
}
- (DNSendButton *)sendButton
{
    if (nil == _sendButton) {
        _sendButton = [[DNSendButton alloc] initWithFrame:CGRectZero];
        [_sendButton addTaget:self action:@selector(sendButtonAction:)];
    }
    return  _sendButton;
}
@end
