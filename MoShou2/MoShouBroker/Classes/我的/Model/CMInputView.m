//
//  CMTextView.m
//  CMInputView
//
//  Created by CrabMan on 16/9/9.
//  Copyright © 2016年 CrabMan. All rights reserved.
//

#import "CMInputView.h"

@interface CMInputView ()

/**
 *  文字高度
 */
@property (nonatomic, assign) NSInteger textH;

/**
 *  文字最大高度
 */
@property (nonatomic, assign) NSInteger maxTextH;


@end

@implementation CMInputView

- (void)textValueDidChanged:(CM_textHeightChangedBlock)block{
    
    _textChangedBlock = block;

}
- (UITextView *)placeholderView
{
    if (!_placeholderView ) {
        UITextView *placeholderView = [[UITextView alloc] initWithFrame:self.bounds];
        //防止textView输入时跳动问题
        placeholderView.scrollEnabled = NO;
        placeholderView.showsHorizontalScrollIndicator = NO;
        placeholderView.showsVerticalScrollIndicator = NO;
        placeholderView.userInteractionEnabled = NO;
        placeholderView.font =  [UIFont systemFontOfSize:15];
        placeholderView.textColor = TFPLEASEHOLDERCOLOR;//[UIColor colorWithHexString:@"888888"];
        placeholderView.backgroundColor = [UIColor clearColor];
        placeholderView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0);
        [self addSubview:placeholderView];
        _placeholderView = placeholderView;
    }
    return _placeholderView;
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    _maxNumberOfLines = maxNumberOfLines;
    
    /**
     *  根据最大的行数计算textView的最大高度
     *  计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
     */
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
    
}

- (void)setCornerRadius:(NSUInteger)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

/**
 *  通过设置placeholder设置私有属性placeholderView中的textColor
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderView.textColor = placeholderColor;
    [self setNeedsDisplay];
}
/**
 *  通过设置placeholder设置私有属性placeholderView中的textColor
 */
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderView.text = placeholder;
}
/**
 *  通过设置_placeholderFont设置私有属性placeholderView中的Font
*/
- (void)setPlaceholderFont:(UIFont *)placeholderFont {

    _placeholderFont = placeholderFont;
    
    self.placeholderView.font = placeholderFont;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //实时监听textView值得改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textDidChange
{
    // 根据文字内容决定placeholderView是否隐藏
    self.placeholderView.hidden = self.text.length > 0;
    
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    
    if (_textH != height) { // 高度不一样，就改变了高度
        
        // 当高度大于最大高度时，需要滚动
//        self.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        BOOL isChange = !self.scrollEnabled;
        self.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        if (self.scrollEnabled && isChange) {
            self.contentOffset = CGPointMake(0,1);
        }
        _textH = height;
        
        //当不可以滚动（即 <= 最大高度）时，传值改变textView高度
        if (_textChangedBlock && self.scrollEnabled == NO) {
            _textChangedBlock(self.text,height);
            
            [self.superview layoutIfNeeded];
            self.placeholderView.frame = self.bounds;

        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
