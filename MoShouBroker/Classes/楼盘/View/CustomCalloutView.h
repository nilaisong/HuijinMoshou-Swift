//
//  CustomCalloutView.h
//  Category_demo2D
//


#import <UIKit/UIKit.h>
@class CustomCalloutView;
@protocol CallOutNavgationActionDelegate <NSObject>

/**
 *  导航开始   查看路线
 */
-(void)CallOutNavgationAction;

@end




@interface CustomCalloutView : UIView

/**
 *  楼盘标题
 */
@property (nonatomic,strong)UILabel *buildTitleLabel;
/**
 *  楼盘盘地址
 */
@property (nonatomic,strong)UILabel *buildLocationLabel;
@property (nonatomic,strong)UILabel *navigationlabel;

@property (nonatomic,weak)id<CallOutNavgationActionDelegate> delegate;

@end
