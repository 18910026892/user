//
//  JLAddFriendCell.m
//  Accompany
//
//  Created by GongXin on 16/2/2.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLAddFriendCell.h"

@implementation JLAddFriendCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _addLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainBoundsWidth - 60, 0, 50, 30)];
        _addLabel.backgroundColor = [UIColor redColor];
        _addLabel.textAlignment = NSTextAlignmentCenter;
        _addLabel.text = NSLocalizedString(@"add", @"Add");
        _addLabel.textColor = [UIColor whiteColor];
        _addLabel.font = [UIFont systemFontOfSize:14.0];
        _addLabel.layer.cornerRadius = 5;
        _addLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_addLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.textLabel.frame;
    rect.size.width -= 70;
    self.textLabel.frame = rect;
    
    rect = _addLabel.frame;
    rect.origin.y = (self.frame.size.height - 30) / 2;
    _addLabel.frame = rect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
