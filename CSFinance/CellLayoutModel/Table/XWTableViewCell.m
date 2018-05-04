//
//  XWTableViewCell.m
//  CSFinance
//
//  Created by csco on 2018/5/3.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWTableViewCell.h"
#import "NSDate+YYAdd.h"

#define kContentH self.contentView.bounds.size.height
#define kContentW self.contentView.bounds.size.width

@implementation XWTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.detailTextLabel.textColor = [UIColor darkGrayColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    switch (_cellStyle) {
        case XWTableViewCellStyleNormal:
            {
//                UITableViewCellStyleSubtitle
            }
            break;
        case XWTableViewCellStyleDuoDetail:
            {
                CGRect rect = self.detailTextLabel.frame;
                CGFloat dWidth = rect.size.width;
                CGFloat dHeight = rect.size.height;
                rect.size.width = dWidth/2;
                rect.size.height = dHeight/2;
                [self.detailTextLabel setFrame:rect];
                
                CGRect eRect = rect;
                eRect.origin.x = rect.origin.x + dWidth/2;
                [self.exTextLabel setFrame:eRect];
            }
            break;
            
        case XWTableViewCellStyleThreeTitle:
            {
                CGFloat tW = (kContentW-20.0)/3;
                [self.textLabel setFrame:CGRectMake(10.0, 5.0, tW, kContentH-10.0)];
                [self.detailTextLabel setFrame:CGRectMake(10.0+tW, 5.0, tW, kContentH-10.0)];
                [self.exTextLabel setFrame:CGRectMake(10.0+tW*2, 5.0, tW, kContentH-10.0)];
                
                self.textLabel.adjustsFontSizeToFitWidth = NO;
                self.textLabel.textColor = [UIColor blackColor];
                self.textLabel.font = [UIFont systemFontOfSize:15];
                self.textLabel.numberOfLines = 0;
                
                self.detailTextLabel.textColor = [UIColor redColor];
                self.detailTextLabel.font = [UIFont systemFontOfSize:15];
                self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
                
                self.exTextLabel.textColor = [UIColor redColor];
                self.exTextLabel.font = [UIFont systemFontOfSize:15];
                self.exTextLabel.textAlignment = NSTextAlignmentCenter;
            }
            break;
            
        case XWTableViewCellStyleFourTitle:
        {
            CGFloat tW = kContentW/4;
            [self.textLabel setFrame:CGRectMake(0, 5.0, tW, kContentH-10.0)];
            [self.detailTextLabel setFrame:CGRectMake(tW, 5.0, tW, kContentH-10.0)];
            [self.exTextLabel setFrame:CGRectMake(tW*2, 5.0, tW, kContentH-10.0)];
            [self.exTextLabel setFrame:CGRectMake(tW*3, 5.0, tW, kContentH-10.0)];
            
            self.textLabel.textColor = [UIColor blackColor];
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            
            self.detailTextLabel.textColor = [UIColor blackColor];
            self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            self.exTextLabel.textColor = [UIColor blackColor];
            self.exTextLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
            
        case XWTableViewCellStylePreview:
            {
                CGFloat xW = kContentW-10.0, xH = kContentH-10.0;
                [self.imageView setFrame:CGRectMake(5.0, 5.0, xW, xH*0.8)];
                [self.textLabel setFrame:CGRectMake(5.0, 5.0+xH*0.8, xW, xH*0.1)];
                [self.detailTextLabel setFrame:CGRectMake(5.0, 5.0+xH*0.9, xW/2, xH*0.1)];
                [self.exTextLabel setFrame:CGRectMake(5.0+xW/2, 5.0+xH*0.9, xW, xH*0.1)];
            }
            break;
            
        case XWTableViewCellStylePoster:
            {
                CGFloat xW = kContentW-10.0, xH = kContentH-10.0;
                [self.imageView setFrame:CGRectMake(5.0, 5.0, xW, xH)];
                [self.textLabel setFrame:CGRectMake(5.0, 5.0+xH*0.8, xW, xH*0.1)];
                [self.detailTextLabel setFrame:CGRectMake(5.0, 5.0+xH*0.9, xW, xH*0.1)];
            }
            break;
            
        default:{
            
        }
            break;
    }
}


- (void)refreshWithLayoutModel:(XWItemLayout*)model
{
    /*
    self.titleLabel.text = model.title;
    if (model.image) {
        self.imageView.image = model.image;
    }
    if (model.detail) {
        self.subtitleLabel.text = model.detail;
    }
    NSString * time = model.linkInfo[@"date"];
    if (time) {
        self.leftLabel.text= time;
    }
    NSString * tag = model.linkInfo[@"tag"];
    if (tag) {
        self.rightLabel.text = tag;
    }
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel*)exTextLabel
{
    if (!_exTextLabel) {
        _exTextLabel =[self instanceNewLabel];
    }
    return _exTextLabel;
}

- (UILabel*)eyTextLabel
{
    if (!_exTextLabel) {
        _eyTextLabel =[self instanceNewLabel];
    }
    return _eyTextLabel;
}

-(UILabel*)instanceNewLabel{
    
    UILabel * la = UILabel.new;
    la.textColor = UIColor.blackColor;
    la.text = @"--";
    la.font =  [UIFont systemFontOfSize:14.0];
    la.textAlignment = NSTextAlignmentCenter;
    la.numberOfLines = 0;
    la.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview: la];
    return la;
}

@end
