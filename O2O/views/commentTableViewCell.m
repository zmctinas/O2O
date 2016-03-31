//
//  commentTableViewCell.m
//  O2O
//
//  Created by wangxiaowei on 15/4/28.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "commentTableViewCell.h"
#import "photoalbumViewController.h"

@implementation commentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)changeLabelFrame
{
    
    CGRect rect = [_commentMessage boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
    CGRect labelFrame = self.messageLabel.frame;
    
    labelFrame.size.height = rect.size.height;
    self.messageLabel.frame = labelFrame;
    
}

-(void)setComModel:(commentModel *)comModel
{
    [super setComModel:comModel];
    _nameLabel.text = comModel.nickname;
    _tiemLabel.text = comModel.commentTime;
    _messageLabel.text = comModel.commentText;
    _commentMessage = comModel.commentText;
    _star.numofStar = [comModel.score integerValue];
    _star.selectingenabled = NO;
    _imageSource = [NSMutableArray arrayWithArray:comModel.picarr];
    [self performSelector:@selector(changeLabelFrame) withObject:nil afterDelay:0];
    
    [self createImage];
}

-(void)setModel:(detailModel *)model
{
    [super setModel:model];
    
    self.comModel = model.comments[self.tag];
    
//    self.messageLabel.text = model.message;
    
//    [self performSelector:@selector(changeLabelFrame) withObject:nil afterDelay:0];
//    
//    [self createImage];
}

-(void)setMerModel:(allMerModel *)merModel
{
    [super setMerModel:merModel];
    
    NSDictionary* dic = merModel.commoditys[self.tag];
    self.messageLabel.text = dic[@"body"];
    _commentMessage = dic[@"body"];
    _nameLabel.text = dic[@"username"];
    NSArray* arr = [dic[@"time"] componentsSeparatedByString:@" "];
    _tiemLabel.text = arr[0];
    _star.numofStar = [dic[@"star"] integerValue];
    _star.selectingenabled = NO;
    _imageSource = [NSMutableArray arrayWithArray:[self.merModel.commoditys[self.tag] objectForKey:@"picarr"]];
    
    [self performSelector:@selector(changeLabelFrame) withObject:nil afterDelay:0];
    
    [self createImage];
}

-(void)addDelegate:(id)delegate andAction:(SEL)action
{
    [super addDelegate:delegate andAction:action];
}

-(void)tapImg:(UITapGestureRecognizer*)tap
{
    UIImageView* imageView = (UIImageView*)tap.view;
    NSDictionary* imagedic = _imageSource[imageView.tag - 100];
    
    NSString* string = imagedic[@"pirurl"];
    
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"image",@"key",string,@"imageName", nil];
    if ([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:dic];
    }
    
}

-(void)createImage
{
    
    for (int i = 0 ; i < 5; i++) {
        UIImageView* imageView = (UIImageView*)[self.contentView viewWithTag:i+100];
        [imageView removeFromSuperview];
    }
    
    NSInteger w=0,h=0;
    
    CGFloat height = [self heightforcell];
    
    for (NSDictionary* dic in _imageSource) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8+w*(8+70), height + 10 + h*(70+10), 70, 70)];
        
        NSString* imageUrl = [NSString stringWithFormat:@"%@%@",HEADIMG,dic[@"pirurl"]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"londing1"]];
        imageView.tag = w+h*4 + 100;
        imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:imageView];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        w++;
        if (w == 4) {
            w=0;
            h++;
        }
    }
}


-(CGFloat)heightforcell
{
    CGRect rect = [_commentMessage boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 10, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
    CGFloat HH = rect.size.height + 60 - 20;
    return HH;
}

@end
