//
//  BuildingImageView.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/8/7.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "BuildingImageView.h"
#import "DownloaderManager.h"

@implementation BuildingImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame andBuildingId:(NSString*)bId
{
    if (self=[super initWithFrame:frame]) {
        self.buildingId = bId;
    }
    return self;
}

-(void)setImageWithUrlString:(NSString *)url
{
//    if ([[DownloaderManager sharedManager] getDownloadStateWithItemId:_buildingId]==kDownloadFinished)//已下载楼盘
//    {
//        NSString* imgPath = [[DownloaderManager sharedManager] getImageDownloadPathWithItemId:_buildingId andImgUrl:url];
//        [self setImageWithUrlString:url toPath:imgPath];
//    }
//    else
    {
        [super setImageWithUrlString:url];
    }
}

-(void)setImageWithUrlString:(NSString *)url placeholderImage:(UIImage *)placeholder
{
//    if ([[DownloaderManager sharedManager] getDownloadStateWithItemId:_buildingId]==kDownloadFinished)//已下载楼盘
//    {
//        NSString* imgPath = [[DownloaderManager sharedManager] getImageDownloadPathWithItemId:_buildingId andImgUrl:url];
//        [self setImageWithUrlString:url toPath:imgPath placeholderImage:placeholder];
//    }
//    else
//    {
        [super setImageWithUrlString:url placeholderImage:placeholder];
//    }
}

@end
