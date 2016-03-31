//
//  productTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/22.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "productTableViewCell.h"
#import <CoreText/CoreText.h>
#import "UIColor+hexColor.h"

@implementation productTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)changeLabelFrame
{
    
    CGRect rect = [self.merModel.message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
    CGRect labelFrame = self.messageLabel.frame;
    
    labelFrame.size.height = rect.size.height;
    self.messageLabel.frame = labelFrame;
    
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//   
//    // Flip the coordinate system
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    CGMutablePathRef path = CGPathCreateMutable(); //1
//    CGPathAddRect(path, NULL, self.bounds );
//    
//    NSAttributedString* attString = [[NSAttributedString alloc]
//                                      initWithString:self.model.message] ; //2
//    
//    CTFramesetterRef framesetter =
//    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); //3
//    CTFrameRef frame =
//    CTFramesetterCreateFrame(framesetter,
//                             CFRangeMake(0, [attString length]), path, NULL);
//    
//    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica"), 15.0, NULL);
//    
//    [attString addAttribute:(id)kCTFontAttributeName
//    
//                   value:(__bridge id)font
//     
//                   range:NSMakeRange(0, [attString length])];
//
//    CTFrameDraw(frame, context); //4
//    
//    CFRelease(frame); //5
//    CFRelease(path);
//    CFRelease(framesetter);
//}

-(void)setModel:(detailModel *)model
{
    [super setModel:model];
    self.messageLabel.text = model.message;
    if (model.message.length<=0) {
        self.messageLabel.text = @"暂无";
    }
    self.messageLabel.textColor = [UIColor colorWithHexString:@"#707070"];
    
    [self performSelector:@selector(changeLabelFrame) withObject:nil afterDelay:0];
}

-(void)setMerModel:(allMerModel *)merModel
{
    [super setMerModel:merModel];
    self.messageLabel.text = merModel.message;
    if (merModel.message.length<=0) {
        self.messageLabel.text = @"暂无";
    }
    [self performSelector:@selector(changeLabelFrame) withObject:nil afterDelay:0];
}

-(CGFloat)heightforcell
{
    CGRect rect = [self.merModel.message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
    CGFloat HH = rect.size.height - 21;
    return HH;
}



@end
