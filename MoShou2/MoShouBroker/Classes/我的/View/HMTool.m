//
//  HMTool.m
//  MoShouQueke
//
//  Created by Aminly on 15/10/30.
//  Copyright © 2015年  5i5j. All rights reserved.
//

#import "HMTool.h"

@implementation HMTool

+(id)creareLineWithFrame:(CGRect)frame andColor:(UIColor*)color{
    UIView *view =[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:color];
    return view;
}
+(CGSize )getTextSizeWithText:(NSString *)text andFontSize:(float)size{
    
    CGSize fsize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}];
    return  fsize;
}

+(UILabel *)setDetailLabelWithText:(NSString *)text andFontSize:(float)fontSize cellHeight:(float)height{
    
    UILabel  *detail =[[UILabel alloc]init];
    detail.text = text;
    detail.textAlignment = NSTextAlignmentRight;
    detail.textColor =[UIColor colorWithHexString:@"#d1d1d1"];
    CGSize fsize = [self getTextSizeWithText:detail.text andFontSize:fontSize];
    [detail setFrame:CGRectMake((kMainScreenWidth-22-15)-fsize.width, (height/2)-(fsize.height/2), fsize.width, fsize.height)];
    detail.adjustsFontSizeToFitWidth  = YES;
    return detail;
}
+(UITableViewCell *)getArrowCellWithFrame:(CGRect)fram{
    UITableViewCell *cell =[[UITableViewCell alloc]init];
    cell.frame =fram;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor whiteColor]];
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-32, cell.frame.size.height/2-11, 22, 22)];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
//    cell.textLabel.textColor= [UIColor colorWithHexString:BTNTITLECOLOR];
    [arrow setImage: [UIImage imageNamed:@"btn-jiantou"]];
    [cell addSubview:arrow];
    
    return cell;
}
- (long long)fileSizeAtPath:(NSString*) filePath{//KB
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (CGFloat)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

-(NSString *)getSizeStrWithPath:(NSString *)path{
    
    NSString *sizeStr =@"";
    float size =[self folderSizeAtPath:path];
    if (size<1 ) {
        
        sizeStr =[NSString stringWithFormat:@"%.2fKB",size*1024];
    }else{
        
        sizeStr = [NSString stringWithFormat:@"%.2fM",size];
    }
    return sizeStr;
    
}
-(void)clearCacheDataSourceWith:(NSString *)path{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
//                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       NSString *allPath = path;
                       //[cachPath stringByAppendingString:@"/ImageCache"];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:allPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [allPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
    
}
-(void)clearCacheSuccess{
    
//    [TipsView showTips:@"清除成功" inView:self.view];
//    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//    [_infoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}
+(UIView *)getLineWithFrame:(CGRect)frame andColor:(UIColor*)color{
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0.5)];
    [line setBackgroundColor:color];
    return line;

}
+(NSString *)removeSpaceStringWithString:(NSString *)string{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}
+(UIButton *)createBtnWithFrame:(CGRect)frame andNormalImage:(UIImage *)normalImage andSelectedImage:(UIImage*)selectedImage{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
    return btn;
}
//+(UIButton *)createBtnWithFrame:(CGRect)frame andNormalColor:(UIColor *)normalColor andSelectedColor:(UIColor*)selectedColor{
//    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
////    btn set
////    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
////    [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
//    return btn;
//}

@end
