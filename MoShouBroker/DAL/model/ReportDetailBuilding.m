//
//  ReportDetailBuilding.m
//  MoShou2
//
//  Created by xiaotei's on 16/1/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "ReportDetailBuilding.h"
#import "NSString+Extension.h"
#import "ReportBuildingTrack.h"
@implementation ReportDetailBuilding

- (CGFloat)trackHeight{
         CGFloat max = 0;
        for (int i = 0;i < _buildingTrackList.count; i++) {
            ReportBuildingTrack* track = _buildingTrackList[i];
            CGSize sizeC = [NSString sizeWithString:track.content font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kMainScreenWidth - 32, CGFLOAT_MAX)];
            max += sizeC.height;
            track.trackHgiht = sizeC.height + 60;
        }
       _trackHeight = max + 28 + 24;
    return _trackHeight;
}

@end
