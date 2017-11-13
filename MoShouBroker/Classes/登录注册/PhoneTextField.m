//
//  PhoneTextField.m
//  MoShou2
//
//  Created by Aminly on 16/2/22.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "PhoneTextField.h"

@implementation PhoneTextField

//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    if (menuController) {
//        [UIMenuController sharedMenuController].menuVisible = NO;
//    }
//    return NO;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(instancetype)init{
//    if (self= [super init]) {
//        self.delegate = super.delegate;
//    }
//    return  self;
//}
-(void)copy:(id)sender

{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    pboard.string = self.text;
    
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    return (action == @selector(paste:));
    
}
//-(void)paste:(id)sender
//
//{
//    
//    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//    if (self.keyboardType == UIKeyboardTypePhonePad&&self.needBlank) {//电话号码特殊粘贴 别的正常粘贴
//        self.text = [self parseString:pboard.string];
//
//    }else{
//        self.text = pboard.string;
// 
//    }
//    
//}
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    return [self phoneTextField:textField shouldChangeCharactersInRange:range replacementString:string];
//}
//-(BOOL)phoneTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    if (textField.keyboardType == UIKeyboardTypePhonePad) {
//        NSString* text = textField.text;
//    
//        //删除
//        if([string isEqualToString:@""]){
//            
//            //删除一位
//            if(range.length == 1){
//                //最后一位,遇到空格则多删除一次
//                if (range.location == text.length-1 ) {
//                    if ([text characterAtIndex:text.length-1] == ' ') {
//                        [textField deleteBackward];
//                    }
//                    return YES;
//                }
//                //从中间删除
//                else{
//                    NSInteger offset = range.location;
//                    
//                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [textField.selectedTextRange isEmpty]) {
//                        [textField deleteBackward];
//                        offset --;
//                    }
//                    [textField deleteBackward];
//                    textField.text = [self parseString:textField.text];
//                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
//                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
//                    return NO;
//                }
//            }
//            else if (range.length > 1) {
//                BOOL isLast = NO;
//                //如果是从最后一位开始
//                if(range.location + range.length == textField.text.length ){
//                    isLast = YES;
//                }
//                [textField deleteBackward];
//                textField.text = [self parseString:textField.text];
//                
//                NSInteger offset = range.location;
//                if (range.location == 3 || range.location  == 8) {
//                    offset ++;
//                }
//                if (isLast) {
//                    //光标直接在最后一位了
//                }else{
//                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
//                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
//                }
//                
//                return NO;
//            }
//            
//            else{
//                return YES;
//            }
//        }
//        
//        else if(string.length >0){
//            
//            //限制输入字符个数
//            if (([self noneSpaseString:textField.text].length + string.length - range.length > 11) ) {
//                return NO;
//            }
//            //            判断是否是纯数字
//            //            if(![self validateNumber:string]){
//            //                return NO;
//            //            }
//            [textField insertText:string];
//            textField.text = [self parseString:textField.text];
//            
//            NSInteger offset = range.location + string.length;
//            if (range.location == 3 || range.location  == 8) {
//                offset ++;
//            }
//            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
//            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
//            return NO;
//        }else{
//            return YES;
//        }
//        //        if ([self validateNumber:string]) {
//        //             return YES;
//        //        }else{
//        //            return  NO;
//        //        }
//    }
//    
//    return YES;
//
//}
//- (BOOL)validateNumber:(NSString*)number {
//    BOOL res = YES;
//    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//    int i = 0;
//    while (i < number.length) {
//        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
//        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
//        if (range.length == 0) {
//            res = NO;
//            break;
//        }
//        i++;
//    }
//    return res;
//}
//-(NSString*)noneSpaseString:(NSString*)string
//{
//    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//}
- (NSString*)parseString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (mStr.length >2) {
        [mStr insertString:@" " atIndex:3];
    }if (mStr.length > 7) {
        [mStr insertString:@" " atIndex:8];
        
    }
    
    return  mStr;
}

@end
