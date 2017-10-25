#import <UIKit/UIKit.h>

@interface ChineseToPinyin : NSObject {
    
}
char pinyinFirstLetter(unsigned short hanzi);
+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 

@end