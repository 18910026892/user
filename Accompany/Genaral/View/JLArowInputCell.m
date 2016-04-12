//
//  JLArowInputCell.m
//  Accompany
//
//  Created by 王园园 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLArowInputCell.h"

@interface JLArowInputCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *inputLable;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;


@end

@implementation JLArowInputCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
   
}

-(void)fillCellWithString:(NSString*)Str WithColor:(UIColor*)color;
{
    _titleLable.text = _title;
    _inputLable.text = Str;
    _inputLable.textColor = color;
    
    _inputLable.textAlignment = NSTextAlignmentRight;
}

+(CGFloat)rowHeightForObject:(id)object
{
    return 44.0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
