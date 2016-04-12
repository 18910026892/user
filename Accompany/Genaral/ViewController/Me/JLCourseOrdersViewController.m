//
//  JLCourseOrdersViewController.m
//  Accompany
//
//  Created by GongXin on 16/3/9.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLCourseOrdersViewController.h"
@interface JLCourseOrdersViewController () {
    int previousStepperValue;
    int totalNumber;
} @end

@implementation JLCourseOrdersViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"我的订单"];
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    [self GetDatas];
    [self setupDatas];
    [self setupViews];
}
-(void)GetDatas
{
 
        [HDHud showHUDInView:self.view title:@"正在提交..."];
        userInfo = [UserInfo sharedUserInfo];
        NSString * token = userInfo.token;
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",nil];
        
        NSLog(@"%@",postDict);
        
        
        HttpRequest * request = [[HttpRequest alloc]init];
        [request RequestDataWithUrl:URL_getOrderCounts pragma:postDict];
        
        
        request.successBlock = ^(id obj){
            
            [HDHud hideHUDInView:self.view];
            NSLog(@"%@",obj);
            
            
        };
        request.failureDataBlock = ^(id error)
        {
            [HDHud hideHUDInView:self.view];
            NSString * message = (NSString *)error;
            [HDHud showMessageInView:self.view title:message];
        };
        
        request.failureBlock = ^(id obj){
            [HDHud hideHUDInView:self.view];
            [HDHud showNetWorkErrorInView:self.view];
        };
        
 
}
-(void)setupViews
{
    
    [self.view addSubview:self.myGraph];
    [self.view addSubview:self.labelValues];
    [self.view addSubview:self.labelDates];
}
-(UILabel*)labelValues
{
    if (!_labelValues) {
        _labelValues = [[UILabel alloc]initWithFrame:CGRectMake(0, kMainBoundsHeight/2+82, kMainBoundsWidth, 40)];
        _labelValues.backgroundColor = [UIColor clearColor];
        _labelValues.textColor = [UIColor whiteColor];
        _labelValues.font = [UIFont systemFontOfSize:24.0f];
        _labelValues.textAlignment = NSTextAlignmentCenter;
    }
    
    return _labelValues;
}
-(UILabel*)labelDates
{
    if (!_labelDates) {
        _labelDates = [[UILabel alloc]initWithFrame:CGRectMake(0, kMainBoundsHeight/2+122, kMainBoundsWidth, 20)];
        _labelDates.backgroundColor = [UIColor clearColor];
        _labelDates.textColor = [UIColor whiteColor];
        _labelDates.font = [UIFont systemFontOfSize:14.0f];
        _labelDates.textAlignment = NSTextAlignmentCenter;
    }
    return _labelDates;
}
-(BEMSimpleLineGraphView*)myGraph
{
    [self setupDatas];
    
    
    if (!_myGraph) {
        _myGraph = [BEMSimpleLineGraphView  new];
        _myGraph.delegate= self;
        _myGraph.dataSource = self;
    
        _myGraph.frame = CGRectMake(0, kMainBoundsHeight/2-206, kMainBoundsWidth, 288);
        
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        size_t num_locations = 2;
        CGFloat locations[2] = { 0.0, 1.0 };
        CGFloat components[8] = {
            1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 0.0
        };
        
        // Apply the gradient to the bottom portion of the graph
        self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        
        
        self.myGraph.colorTop = [UIColor clearColor];
        self.myGraph.colorBottom = [UIColor clearColor];
        self.myGraph.tintColor = [UIColor redColor];
        self.myGraph.colorXaxisLabel = [UIColor whiteColor];
        self.myGraph.colorYaxisLabel = [UIColor whiteColor];
        
        // Enable and disable various graph properties and axis displays
        self.myGraph.enableTouchReport = YES;
        self.myGraph.enablePopUpReport = YES;
        self.myGraph.enableYAxisLabel = YES;
        self.myGraph.autoScaleYAxis = YES;
        self.myGraph.alwaysDisplayDots = NO;
        self.myGraph.enableReferenceXAxisLines = YES;
        self.myGraph.enableReferenceYAxisLines = YES;
        self.myGraph.enableReferenceAxisFrame = YES;
        
        // Draw an average line
        self.myGraph.averageLine.enableAverageLine = NO;
        self.myGraph.averageLine.alpha = 0.6;
        self.myGraph.averageLine.color = [UIColor darkGrayColor];
        self.myGraph.averageLine.width = 2.5;
        self.myGraph.averageLine.dashPattern = @[@(2),@(2)];
        
        // Set the graph's animation style to draw, fade, or none
        self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
        
        // Dash the y reference lines
        self.myGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
        
        // Show the y axis values with this format string
        self.myGraph.formatStringForValues = @"%1.0f";
        
        // Setup initial curve selection segment
    
        
    }
    return _myGraph;
}


-(void)setupDatas
{
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    
    previousStepperValue = 1;
    
    totalNumber = 0;
    NSDate *baseDate = [NSDate date];
    BOOL showNullValue = true;
    
    // Add objects to the array based on the stepper value
    for (int i = 0; i < 9; i++) {
        [self.arrayOfValues addObject:@([self getRandomFloat])]; // Random values for the graph
        if (i == 0) {
            [self.arrayOfDates addObject:baseDate]; // Dates for the X-Axis of the graph
        } else if (showNullValue && i == 4) {
            [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
            self.arrayOfValues[i] = @(BEMNullGraphValue);
        } else {
            [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
        }
        
        totalNumber = totalNumber + [[self.arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
    
    NSLog(@"%@---%@",self.arrayOfValues,self.arrayOfDates);

}

- (NSDate *)dateForGraphAfterDate:(NSDate *)date {
    NSTimeInterval secondsInTwentyFourHours = 24 * 60 * 60;
    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwentyFourHours];
    return newDate;
}

- (NSString *)labelForDateAtIndex:(NSInteger)index {
    NSDate *date = self.arrayOfDates[index];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd";
    NSString *label = [df stringFromDate:date];
    return label;
}

#pragma mark - Graph Actions

// Refresh the line graph using the specified properties


- (float)getRandomFloat {
    float i1 = (float)(arc4random() % 1000000) / 100 ;
    return i1;
}

- (IBAction)displayStatistics:(id)sender {
    [self performSegueWithIdentifier:@"showStats" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"showStats"]) {
        NSLog(@"statsVc");
//        StatsViewController *controller = segue.destinationViewController;
//        controller.standardDeviation = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculateLineGraphStandardDeviation] floatValue]];
//        controller.average = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculatePointValueAverage] floatValue]];
//        controller.median = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculatePointValueMedian] floatValue]];
//        controller.mode = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculatePointValueMode] floatValue]];
//        controller.minimum = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculateMinimumPointValue] floatValue]];
//        controller.maximum = [NSString stringWithFormat:@"%.2f", [[self.myGraph calculateMaximumPointValue] floatValue]];
//        controller.snapshotImage = [self.myGraph graphSnapshotImage];
    }
}


#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 2;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.arrayOfValues objectAtIndex:index]];
    self.labelDates.text = [NSString stringWithFormat:@" %@", [self labelForDateAtIndex:index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelValues.alpha = 0.0;
        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.labelValues.text = [NSString stringWithFormat:@"总订单数:%i", [[self.myGraph calculatePointValueSum] intValue]];
        self.labelDates.text = [NSString stringWithFormat:@" %@ 与 %@ 的数据", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.labelValues.alpha = 1.0;
            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    self.labelValues.text = [NSString stringWithFormat:@"总订单数:%i", [[self.myGraph calculatePointValueSum] intValue]];
    self.labelDates.text = [NSString stringWithFormat:@" %@ 与 %@ 的数据", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
}

/* - (void)lineGraphDidFinishDrawing:(BEMSimpleLineGraphView *)graph {
 // Use this method for tasks after the graph has finished drawing
 } */

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @" 单";
}



@end
