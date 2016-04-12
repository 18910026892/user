//
//  JLCustomPickerView.m
//  Accompany
//
//  Created by 王园园 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLCustomPickerView.h"

#define WINDOW_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.25f
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.8]
#define VIEWHeight  225.0

@interface JLCustomPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIToolbar* toolBar;
}
@property (nonatomic,strong)UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end
@implementation JLCustomPickerView



-(id)init{
    self = [super init];
    if (self) {
        
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        //生成LZWActionSheetView
        self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, (kMainBoundsHeight - 0), kMainBoundsWidth, VIEWHeight)];
        self.backGroundView.backgroundColor = [UIColor whiteColor] ;
        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 44)];
        toolBar.tintColor = [UIColor redColor];
        toolBar.barStyle = UIBarStyleDefault;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStyleDone target: self action: @selector(done)];
        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(docancel)];
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton,rightButton, nil];
        [toolBar setItems: array];
        
        [self addSubview:self.backGroundView];
        [self.backGroundView addSubview:toolBar];
        

        [self.backGroundView addSubview:self.picker];
        
        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-VIEWHeight, [UIScreen mainScreen].bounds.size.width, VIEWHeight)];
        } completion:^(BOOL finished) {
            
        }];
    }
    return self;
}

-(UIPickerView *)picker
{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, kMainBoundsWidth, VIEWHeight-50)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}



#pragma mark -- 数据源 --
-(void)loadData:(NSMutableArray *)dataArray
{
    self.dataArray = [[NSMutableArray alloc] initWithArray:dataArray];
    
    [self.pickerView reloadAllComponents];
}


#pragma mark -- UIPickerView delegate --
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict =   [self.dataArray objectAtIndex:row];
    return  dict[@"name"];
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *mycom1 = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, pickerView.width, 20.0f)];
    NSDictionary *dict = [self.dataArray objectAtIndex:row];
    mycom1.text = dict[@"name"];
    [mycom1 setFont:[UIFont systemFontOfSize: 15]];
    mycom1.backgroundColor = [UIColor clearColor];
    mycom1.textAlignment = NSTextAlignmentCenter;
    return mycom1;
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}





- (void)tappedBackGroundView
{
    //
}
- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)showInView:(UIView *)view{

    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
}




-(void)done{
    [self tappedCancel];
    NSInteger index = [self.pickerView selectedRowInComponent:0];
    NSDictionary *dict;
    if([self.dataArray count]>0)
    {
        dict = [self.dataArray objectAtIndex:index];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(PickerView:didSelectMenuPickerData:)]) {
        [self.delegate PickerView:self didSelectMenuPickerData:dict];
    }
}
-(void)docancel
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(PickerView:didCancelMenuPickerData:)]) {
        [self.delegate PickerView:self didCancelMenuPickerData:nil];
    }
    [self tappedCancel];
}




@end
