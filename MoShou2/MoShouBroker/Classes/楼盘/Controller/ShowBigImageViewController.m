//
//  ShowBigImageViewController.m
//  MoShouBroker
//
//  Created by strongcoder on 15/7/29.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "ShowBigImageViewController.h"
#import "MyImageView.h"
#import "VIPhotoView.h"
@interface ShowBigImageViewController ()
@property (nonatomic,strong)UIScrollView *ImageScrollView;

@property (nonatomic,strong)MyImageView *myBigImageView;

@property (nonatomic,strong)UIImage *myBigImage;

@end

@implementation ShowBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.imageURL.length!=0)
    {
        self.myBigImage= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]];
        
    }else if (self.bigImage !=nil)
    {
        self.myBigImage = self.bigImage;
    }
    
    VIPhotoView *bigImageView = [[VIPhotoView alloc]initWithFrame:self.view.bounds andImage:self.myBigImage];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myImageViewTapAction:)];
    [bigImageView addGestureRecognizer:tapGesture];
    [self.view addSubview:bigImageView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"%@", NSStringFromCGRect([[[self.view subviews] lastObject] frame]));
}

-(void)myImageViewTapAction:(UITapGestureRecognizer *)tap
{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

@end
