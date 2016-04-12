//
//  CoachListTableViewCell.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/6.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "CoachListTableViewCell.h"

@implementation CoachListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
    }
    return self;
}
- (void)setCocahModel:(CocahModel *)cocahModel
{
    _cocahModel = cocahModel;
    
    
    [self.contentView addSubview:self.cocahImageView];
    [self.contentView addSubview:self.cocahNameLabel];
    [self.contentView addSubview:self.StarView];
    [self.contentView addSubview:self.cocahInfoLabel];
    [self.contentView addSubview:self.cocahPriceLabel];
    [self.contentView addSubview:self.venueNameLabel];
    
    
    NSString * userPhoto =cocahModel.userPhoto;
    UIImage * tianchongImage = [UIImage imageNamed:@"coachtianchong"];
    
    [_cocahImageView sd_setImageWithURL:[NSURL URLWithString:userPhoto] placeholderImage:tianchongImage];
    
    
    _cocahNameLabel.text = cocahModel.nikeName;
   
    
    _StarView.rate = [cocahModel.userLevel intValue];
    
    NSString * price = [NSString stringWithFormat:@"%@", [cocahModel.grssCourse valueForKey:@"price"]];
    
    if ([price isEmpty]) {
        _cocahPriceLabel.text = @"暂无课程定价";
    }else
    {
        _cocahPriceLabel.text =[NSString stringWithFormat:@"￥ %@元",price];
    }

    
    _venueNameLabel.text = [cocahModel.grssClub valueForKey:@"clubName"];
    
    
    NSString * sex;
    if ([cocahModel.userSex isEqualToString:@"1"]) {
        sex = @"男";
    }else if([cocahModel.userSex isEqualToString:@"2"])
    {
        sex = @"女";
    }
    NSString * age;
    NSString * realAge ;
    if ([cocahModel.birthday length]>10) {
         age = [cocahModel.birthday substringToIndex:10];
         realAge =[NSString stringWithFormat:@"%@岁",[self getAgeFromBirthday:age]];
    }else
    {
        age = @"";
        realAge = @"";
    }
  
    NSString * constellation = cocahModel.constellation;
    
    NSString * info = [NSString stringWithFormat:@"%@ %@ %@",sex,realAge,constellation];
    
    _cocahInfoLabel.text = info;
    
}




-(NSString*)getAgeFromBirthday:(NSString*)birthday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //定义一个NSCalendar对象
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birthday];
    //用来得到具体的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0]; if([date year] >0) { NSLog(@"%@",[NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]]) ; } else if([date month] >0) { NSLog(@"%@",[NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]]); } else if([date day]>0){ NSLog(@"%@",[NSString stringWithFormat:(@"%ld天"),(long)[date day]]); } else { NSLog(@"0天");}
    
    NSString * age = [NSString stringWithFormat:@"%ld",(long)[date year]];
    return age;
    
}
-(UIImageView*)cocahImageView
{
    if(!_cocahImageView)
    {
        _cocahImageView = [[UIImageView alloc]init];
        _cocahImageView.backgroundColor = [UIColor clearColor];
        _cocahImageView.frame = CGRectMake(20, 10, 80, 80);
        
    }
    return _cocahImageView;
        
}
-(UILabel*)cocahNameLabel
{
    if (!_cocahNameLabel) {
        _cocahNameLabel = [[UILabel alloc]init];
        _cocahNameLabel.frame = CGRectMake(120, 10, kMainBoundsWidth-140, 20);
        _cocahNameLabel.backgroundColor = [UIColor clearColor];
        
        _cocahNameLabel.textColor = [UIColor whiteColor];
        _cocahNameLabel.font = [UIFont systemFontOfSize:14];
        _cocahNameLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _cocahNameLabel;
}
-(DJQRateView*)StarView
{
    if (!_StarView) {
       _StarView = [[DJQRateView alloc]initWithFrame:CGRectMake(120, 30, 120, 15)];

        _StarView.tintColor = [UIColor orangeColor];
    }
   
    return _StarView;
}
-(UILabel*)cocahInfoLabel
{
    if (!_cocahInfoLabel) {
        _cocahInfoLabel = [[UILabel alloc]init];
        _cocahInfoLabel.frame = CGRectMake(120, 45, kMainBoundsWidth-140, 15);
        _cocahInfoLabel.textColor = [UIColor grayColor];
        _cocahInfoLabel.font = [UIFont systemFontOfSize:12];
        _cocahInfoLabel.backgroundColor = [UIColor clearColor];
        _cocahInfoLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _cocahInfoLabel;
}

-(UILabel*)cocahPriceLabel
{
    if (!_cocahPriceLabel) {
        _cocahPriceLabel = [[UILabel alloc]init];
        _cocahPriceLabel.frame = CGRectMake(120, 60, kMainBoundsWidth-140, 15);
        _cocahPriceLabel.textColor = [UIColor grayColor];
        _cocahPriceLabel.font = [UIFont systemFontOfSize:12];
        _cocahPriceLabel.backgroundColor = [UIColor clearColor];
        _cocahPriceLabel.textAlignment = NSTextAlignmentLeft;
        
        _cocahPriceLabel.textColor = [UIColor orangeColor];
    }
    return _cocahPriceLabel;
}
-(UILabel*)venueNameLabel;
{
    if (!_venueNameLabel) {
        _venueNameLabel = [[UILabel alloc]init];
        _venueNameLabel.frame = CGRectMake(120, 75, kMainBoundsWidth-140, 15);
        _venueNameLabel.textColor = [UIColor grayColor];
        _venueNameLabel.font = [UIFont systemFontOfSize:12];
        _venueNameLabel.backgroundColor = [UIColor clearColor];
        _venueNameLabel.textAlignment = NSTextAlignmentLeft;
        _venueNameLabel.textColor = [UIColor grayColor];
    }
    return _venueNameLabel;
}


@end
