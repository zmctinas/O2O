//
//  delLineLabel.m
//  TiaoWei
//
//  Created by dukai on 15/2/13.
//  Copyright (c) 2015年 longcai. All rights reserved.
//

#import "delLineLabel.h"

@implementation delLineLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //调用 super的目的 就是先把文字画上去
    [super drawRect:rect];
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置线条颜色就是标签文字颜色
    [self.textColor setStroke];
    
    //画线的起点
    CGFloat y = self.frame.size.height * 0.5;
    CGContextMoveToPoint(context, 0, y);
    
    //短标题，根据字体确定横线的宽度
    CGSize size = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil]];
    //线条的终点(文字有多长就画多长)
    CGContextAddLineToPoint(context, size.width+1, y);
    //最后 渲染到上下文中
    CGContextStrokePath(context);
    
}


@end
