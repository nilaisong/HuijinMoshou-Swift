//
//  DNImagePickerController.m
//  ImagePicker
//
//  Created by DingXiao on 15/2/10.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "DNImagePickerController.h"
#import "DNAlbumTableViewController.h"
#import "DNImageFlowViewController.h"

NSString *kDNImagePickerStoredGroupKey = @"com.dennis.kDNImagePickerStoredGroup";

ALAssetsFilter * ALAssetsFilterFromDNImagePickerControllerFilterType(DNImagePickerFilterType type)
{
    switch (type) {
        default:
        case DNImagePickerFilterTypeNone:
            return [ALAssetsFilter allAssets];
            break;
        case DNImagePickerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
        case DNImagePickerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
    }
}

@interface DNImagePickerController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<UINavigationControllerDelegate> navDelegate;
@property (nonatomic, assign) BOOL isDuringPushAnimation;

@end

@implementation DNImagePickerController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.delegate) {
        self.delegate = self;
    }
    
    self.interactivePopGestureRecognizer.delegate = self;
    
    NSString *propwetyID = [[NSUserDefaults standardUserDefaults] objectForKey:kDNImagePickerStoredGroupKey];
    

    if (propwetyID.length <= 0) {
        [self showAlbumList];
//        [self showFirstAssetsController];

    } else {
        ALAssetsLibrary *assetsLibiary = [self defaultAssetsLibrary];
        [assetsLibiary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop)
         {
          
             if (assetsGroup == nil && *stop ==  NO) {
                 [self showAlbumList];
//                 [self showFirstAssetsController];
             }
            

             NSString *assetsGroupID= [assetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
             if ([assetsGroupID isEqualToString:propwetyID]) {
                 *stop = YES;
                 NSURL *assetsGroupURL = [assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
                 DNAlbumTableViewController *albumTableViewController = [[DNAlbumTableViewController alloc] init];
//                 andSelectedArr
//                 DNImageFlowViewController *imageFlowController = [[DNImageFlowViewController alloc] initWithGroupURL:assetsGroupURL];
                 DNImageFlowViewController *imageFlowController =nil;
                 if (self.selectedArr.count>0) {
                     imageFlowController = [[DNImageFlowViewController alloc]initWithGroupURL:assetsGroupURL andSelectedArr:self.selectedArr];
                 }else{
                  imageFlowController = [[DNImageFlowViewController alloc] initWithGroupURL:assetsGroupURL];
                 }
                 
                 [self setViewControllers:@[albumTableViewController,imageFlowController]];
             }
         }
                                   failureBlock:^(NSError *error)
         {
             [self showAlbumList];
//             [self showFirstAssetsController];

         }];
    }
}

-(instancetype)initWithSelectedArr:(NSMutableArray *)arr{
    if (self = [super init]) {
        self.selectedArr = [[NSMutableArray alloc]init];
        if (arr.count>0) {
            self.selectedArr = arr;
        }
    }
    return  self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - priviate methods
- (void)showAlbumList
{
    NSLog(@"hxhxhxhxhx%zd",self.selectedArr.count);
    DNAlbumTableViewController *albumTableViewController = [[DNAlbumTableViewController alloc] init];

    [self setViewControllers:@[albumTableViewController]];

}
//-(void)showFirstAssetsController{
//    
//    ALAssetsGroup *group = self.assetsGroups[0];
//        NSURL *url = [group valueForProperty:ALAssetsGroupPropertyURL];
//        if (self.selectedArr.count>0) {
//            DNImageFlowViewController *imageFlowViewController = [[DNImageFlowViewController alloc] initWithGroupURL:url andSelectedArr:self.selectedArr];
//            [self.navigationController pushViewController:imageFlowViewController animated:YES];
//            
//        }else{
//            DNImageFlowViewController *imageFlowViewController = [[DNImageFlowViewController alloc] initWithGroupURL:url];
//            [self.navigationController pushViewController:imageFlowViewController animated:YES];
//            
//        }
//        
//
//
//}
#pragma mark - UINavigationController

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    [super setDelegate:delegate ? self : nil];
    self.navDelegate = delegate != self ? delegate : nil;
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated __attribute__((objc_requires_super))
{
    self.isDuringPushAnimation = YES;
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    self.isDuringPushAnimation = NO;
    if ([self.navDelegate respondsToSelector:_cmd]) {
        [self.navDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return [self.viewControllers count] > 1 && !self.isDuringPushAnimation;
    } else {
        return YES;
    }
}

#pragma mark - Delegate Forwarder

- (BOOL)respondsToSelector:(SEL)s
{
    return [super respondsToSelector:s] || [self.navDelegate respondsToSelector:s];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)s
{
    return [super methodSignatureForSelector:s] ?: [(id)self.navDelegate methodSignatureForSelector:s];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    id delegate = self.navDelegate;
    if ([delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:delegate];
    }
}


@end
