//
//  JLBuyCourseViewController.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/21.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLBuyCourseViewController.h"
#import "JLExchangeVoucherViewController.h"
#import "JLPaySuccessViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import <QuartzCore/QuartzCore.h>
#import "SNY_Toast.h"
@implementation JLBuyCourseViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHide:NO];
    [self showBackButton:YES];
    [self setNavTitle:@"购买课程"];
    [self setupViews];
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addExchange:) name:@"addExchange" object:nil];
    
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaySuccesessPoP) name:@"PaySuccesess" object:nil];
    
    _IsAlipay = NO;
    _IsWechatpay = NO;
}


- (void)addExchange:(NSNotification *)notification
{
    NSLog(@"loginStateChange");
    JLExchangeModel * model = (JLExchangeModel*)notification.object;
    
    _Discount  = model.price;
    
    _promoId = model.id;
    
    //一个cell刷新

    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [self.TableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:1];
    [self.TableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)setupViews
{
    
    [self.view addSubview:self.TableView];
    
}
-(UIButton*)SubmitButton
{
    if (!_SubmitButton) {
        
        _SubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _SubmitButton.frame = CGRectMake(20,22.5, kMainScreenWidth-40, 35);
        _SubmitButton.backgroundColor = [UIColor redColor];
        [_SubmitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_SubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _SubmitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _SubmitButton.layer.cornerRadius = 17.5;
        [_SubmitButton addTarget:self action:@selector(SubmitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _SubmitButton;
}
-(void)SubmitButtonClick:(UIButton*)sender
{
    
    if(_IsAlipay==NO&&_IsWechatpay==NO)
    {
        [HDHud showMessageInView:self.view title:@"亲，请先选择一种支付方式"];
    }else
    {
        
        
        
      [HDHud showHUDInView:self.view title:@"支付中..."];
        userInfo = [UserInfo sharedUserInfo];
        
        NSString * courtseID = [self.coachModel.grssCourse valueForKey:@"id"];
        
        NSString * userComment = @"";
        NSString * channel;
        
        if (_IsWechatpay==YES&&!_IsAlipay) {
            channel = @"0";
        }else  if (_IsWechatpay==YES&&!_IsAlipay)
        {
            channel = @"1";
            
           
          
        }

        
        NSString * attach = @"教练随行订单支付";
        NSString * body = [NSString stringWithFormat:@"教练随行订单%@",courtseID];
        
        NSString * promoId = self.promoId;
        
        userInfo = [UserInfo sharedUserInfo];
        
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.token,@"token",_amount,@"amount",courtseID,@"courseId",userComment,@"userComment",channel,@"channel",attach,@"attach",body,@"body",promoId,@"promoId", nil];
        
        
        
        HttpRequest * request = [[HttpRequest alloc]init];
        [request RequestDataWithUrl:URL_creatOrder pragma:postDict];
        
        request.successBlock = ^(id obj){
            
            
            
            _OrderDict = obj[0];
            
     
            if (_IsAlipay==YES&&_IsWechatpay==NO) {
                
                [self zhifubaoMethod:_OrderDict];
                
                
            }else if(_IsWechatpay==YES&&_IsAlipay==NO)
            {
                
                [self wxpayWithDict:_OrderDict];
                
            }
            
            [HDHud hideHUDInView:self.view];
        };
        request.failureDataBlock = ^(id error)
        {
            [HDHud hideHUDInView:self.view];
            NSString * message = (NSString *)error;
            [HDHud showMessageInView:self.view title:message];
        };
        
        request.failureBlock = ^(id obj){
            
            [HDHud showNetWorkErrorInView:self.view];
        };

        
    }



    
}



-(UIView*)FooterView
{
    if (!_FooterView) {
        _FooterView = [[UIView alloc]init];
        _FooterView.frame = CGRectMake(0, 0, kMainBoundsWidth, 80);
        _FooterView.backgroundColor = [UIColor clearColor];
        
        [_FooterView addSubview:self.SubmitButton];
    }
    
    return _FooterView;
    
}
-(UITableView*)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 63.9, kMainBoundsWidth, kMainBoundsHeight-63.9) style:UITableViewStyleGrouped];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _TableView.separatorColor = [UIColor lightGrayColor];
        _TableView.tableFooterView = self.FooterView;
    }
    
    return _TableView;
}

#pragma TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section==0&&indexPath.row==0) {
        return 70;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section==1) {
        return 30;
    }else
    return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return .1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    
    NSString * str;
    if (section==0) {
        str= @"";
    }else
    {
        str = @"     选择支付方式";
    }
    
  
    _sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 20)];
    _sectionTitle.backgroundColor = [UIColor clearColor];
    _sectionTitle.textColor = [UIColor grayColor];
    _sectionTitle.textAlignment = NSTextAlignmentLeft;
    _sectionTitle.font = [UIFont systemFontOfSize:14.0f];
    _sectionTitle.text = str;
  
    return _sectionTitle;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
 
    
    UITableViewCell * cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor grayColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:_cellTitle];
        
        
        
        _cellImageView = [[UIImageView alloc]init];
        _cellImageView.frame = CGRectMake(15, 10, 50, 50);
        _cellImageView.backgroundColor = GXRandomColor;
        _cellImageView.layer.cornerRadius = 25;
        _cellImageView.hidden = YES;
        [cell.contentView addSubview:_cellImageView];
        
        
        _cellContent = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, kMainBoundsWidth-160, 20)];
        _cellContent.backgroundColor = [UIColor clearColor];
        _cellContent.textColor = [UIColor redColor];
        _cellContent.textAlignment = NSTextAlignmentRight;
        _cellContent.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:_cellContent];
        
    }

    
    switch (indexPath.section) {
        case 0:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    _cellImageView.hidden = NO;
                    
                    NSString * tianChongImage = @"userPhoto";
                    NSString * photoURL = self.coachModel.userPhoto;
                    
                    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:[UIImage imageNamed:tianChongImage]];
                    
                    
                    
                    _cellTitle.frame = CGRectMake(80, 15, kMainScreenWidth/2, 20);
                    _cellTitle.textColor = [UIColor whiteColor];
                    _cellTitle.text = self.coachModel.nikeName;
                    
                    _otherLabel = [[UILabel alloc]init];
                    _otherLabel.frame = CGRectMake(80, 35, kMainScreenWidth/2, 20);
                    _otherLabel.backgroundColor =[UIColor clearColor];
                    _otherLabel.font = [UIFont systemFontOfSize:12];
                    _otherLabel.textAlignment = NSTextAlignmentLeft;
                    _otherLabel.textColor = [UIColor grayColor];

                    NSString * sex;
                    if ([self.coachModel.userSex isEqualToString:@"1"]) {
                        sex = @"男";
                    }else if([self.coachModel.userSex isEqualToString:@"2"])
                    {
                        sex = @"女";
                    }
                    _otherLabel.text = sex;
                    [cell.contentView addSubview:_otherLabel];
                }
                    break;
                case 1:
                {
                    _cellTitle.text = @"价格";
                    
                    _price = [NSString stringWithFormat:@"%@",   [self.coachModel.grssCourse valueForKey:@"price"]];
             
                    
                    if ([_price isEmpty]) {
                       _cellContent.text = @"暂无课程定价";
                    }else
                    {
                        _cellContent.text =[NSString stringWithFormat:@"￥ %@元",_price];
                    }

                    
                }
                    break;
                case 2:
                {
                    _cellTitle.text = @"优惠券";
                    
                    if (!_Discount) {
                        _cellContent.text = @"";
                    }else
                    {
                        _cellContent.text = [NSString stringWithFormat:@"%@元",_Discount];
                    }
                   
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                default:
                    break;
            }
            
            
            
                   }
            break;
            case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    _cellImageView.hidden = NO;
                    _cellImageView.frame = CGRectMake(15, 10, 23,23);
                    _cellImageView.layer.cornerRadius = 15;
                     [_cellImageView setImage:[UIImage imageNamed:@"wechatpay"]];
                    _cellTitle.text = @"微信";
                    _cellTitle.frame = CGRectMake(60, 12, 80, 20);
                    
                    _wechatpayImage = [[UIImageView alloc]init];
                    _wechatpayImage.frame = CGRectMake(kMainBoundsWidth-45, 14, 15, 15);
                    if (_IsWechatpay&&!_IsAlipay) {
                        _wechatpayImage.image  = [UIImage imageNamed:@"payselect"];
                    }else if(!_IsWechatpay)
                    {
                         _wechatpayImage.image  = [UIImage imageNamed:@"payunselect"];
                    }
                  
                    [cell.contentView addSubview:_wechatpayImage];
                }
                    break;
                case 1:
                {
                    _cellImageView.hidden = NO;
                    _cellImageView.frame = CGRectMake(15, 10, 23, 23);
                    _cellImageView.layer.cornerRadius = 15;
                    [_cellImageView setImage:[UIImage imageNamed:@"alipay"]];
                    
                    _cellTitle.text = @"支付宝";
                    _cellTitle.frame = CGRectMake(60, 12, 80, 20);
                    
                    _alipayImage = [[UIImageView alloc]init];
                    _alipayImage.frame = CGRectMake(kMainBoundsWidth-45, 14, 15, 15);
                    if (_IsAlipay&&!_IsWechatpay) {
                        _alipayImage.image  = [UIImage imageNamed:@"payselect"];
                    }else if(!_IsAlipay)
                    {
                        _alipayImage.image  = [UIImage imageNamed:@"payunselect"];
                    }
                    
                    [cell.contentView addSubview:_alipayImage];
                    
                    
                }
                    break;
                case 2:
                {
                    _cellTitle.text = @"总计";
                    _cellTitle.textColor = [UIColor whiteColor];

                    double p =  [_price doubleValue];
                    double d  = [_Discount doubleValue];
                    double a  = p-d ;
                    
                    if (a<1) {
                        a=1.00;
                    }
                    
                  

                    _cellContent.text = [NSString stringWithFormat:@"%.0f元",a];
                    
                    _amount = [NSString stringWithFormat:@"%.2f",a];
                    
                }
                    break;
                default:
                    break;
            }

        }
            break;
        default:
            break;
    }
    

    
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    
    if(indexPath.section==0)
    {
        if (indexPath.row==2) {
            JLExchangeVoucherViewController * exchangeVC = [JLExchangeVoucherViewController viewController];
            exchangeVC.CoachModel = self.coachModel;
            [self.navigationController pushViewController:exchangeVC animated:YES];
        }
    }else if(indexPath.section==1)
    {
        if (indexPath.row==0) {
            
            _IsWechatpay = YES;
            _IsAlipay = NO;
            
        }else if(indexPath.row==1)
        {
             _IsAlipay = YES;
            _IsWechatpay = NO;
        }
        
        
        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:0 inSection:1];
        [_TableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];
    
        NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:1 inSection:1];
        [_TableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];
    
        

    }
        
}




#pragma mark
#pragma mark ===========Pay=============

//支付宝
-(void)zhifubaoMethod:(NSDictionary*)dict;
{
    NSLog(@"调起支付宝");
    
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088121913145957";//
    NSString *seller = @"joinuswo@126.com";//
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANS4Vp5ncIqVGw0BkacjtQR/kSfTB1jOBdt2nNkmpea0JmgDlOqT2NTKSVGrhrVLClPiNPTCbHCs196x1xjkuIEvztMeoXWrkU7bHlTUoYLqq/cU9DNvSjCb8yjSTmQlAahhM98lSOSPgo3ak9tsJhz1eYqdtotXdRPKtG6cO5uPAgMBAAECgYB/TotYZeOurKnx0LyQ4QfW11nSEbPV7AcJXyVjuIOVXL+XhH09HpqoTyAuJo+KNIzLwxeaXDl1/Zt8BccLeOcKIepsBD9vj8HJt3x0yIwpYOiZ0DyI8MbQAQtupQDatWGfr9+Hf3xBKgfwPvLmR03THj6vqMCQsjDAv4pqSgkrUQJBAPhraIrgwzEo6PguuhQilA7TGj+LMScUxiE+CqczUmXBCZ+Me/Lc2pDBSPB2hLtUvfuL9YLU9c0DMIO7yqPxN4sCQQDbNg3xPDo7HRtGbn/rbIcMFNcwWru68OQTy1MWBucmkmVV7Nac53+ij6ZHGmS8QJ0SvqrX6ckcoEMd9hvyAIyNAkEAstJehtoUqCaSzVSVjjj161X65xMDZuaFWRiYApPnFGhIzRkLgF+K1fjM0IwAL/loaNLvACbcaZ+KJMnhrPHO0QJAB2Kq1ZXR4Gv6n0TZynS9mAqbtWVZLdMv2/rdscBJyWLlRx/TmzWxdyif0YVyH2WN5TPHTb7yp6Q+nqPMDTs3gQJBAJ9t3+wyDBtPb24S4Fz8l14IMtTSmoOmMoCgkIizO60O1nllHot3yDHZmwi3y1TASiwaOMySKgy8TD4ysgfxc7I=";
    
    /*============================================================================*/
    /*============================================================================*/
    
    _CreatOrderNum = [dict objectForKey:@"orderNo"];
    
    _CreatOrderMonay = _amount;
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = _CreatOrderNum; //订单ID（由商家自行制定）    ///
    order.productName = @"教练随行课程订单"; //商品标题
    order.productDescription = @"教练随行视频课程"; //商品描述
    
    order.amount = _CreatOrderMonay; //商品价格                //
    order.notifyURL =  @"http://grss.goodbuild.cn/grss/api/updateOrderStatusAli"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"accompanyAliPay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    NSLog(@"signer:%@",signer);
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        
        //网页支付回调
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"resultDic = %@",resultDic);
            
            [self AliPayResult:resultDic];
        }];
    }
}
-(NSString *)getRandomString
{
    NSString *str = [NSString stringWithFormat:@"%s",genRandomString(32)];
    return str;
}
char* genRandomString(int length)
{
    int flag, i;
    char* string;
    srand((unsigned) time(NULL ));
    if ((string = (char*) malloc(length)) == NULL )
    {
        //NSLog(@"Malloc failed!flag:14\n");
        return NULL ;
    }
    
    for (i = 0; i < length - 1; i++)
    {
        flag = rand() % 3;
        switch (flag)
        {
            case 0:
                string[i] = 'A' + rand() % 26;
                break;
            case 1:
                string[i] = 'a' + rand() % 26;
                break;
            case 2:
                string[i] = '0' + rand() % 10;
                break;
            default:
                string[i] = 'x';
                break;
        }
    }
    string[length - 1] = '\0';
    return string;
}
-(void)AliPayResultNotify:(NSNotification *)notify
{
    NSDictionary *dict = [notify object];
    [self AliPayResult:dict];
}

#pragma mark -
#pragma mark   ==============查询账户是否存在==============

- (IBAction)checkAccount:(id)sender {
    BOOL hasAuthorized = [[AlipaySDK defaultService] isLogined];
    NSLog(@"result = %d",hasAuthorized);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询账户"
                                                    message:hasAuthorized?@"有":@"没有"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
    [alert show];
}


#pragma mark -
#pragma mark    ----支付宝回调结果结果判断-----
-(void)AliPayResult:(NSDictionary *)resultDic
{
    /*
     9000 订单支付成功
     8000 正在处理中
     4000 订单支付失败
     6001 用户中途取消
     6002 网络连接出错
     */
    NSLog(@"result = %@", resultDic[@"resultStatus"]);
    NSDictionary *stateDict = @{@"9000":@"订单支付成功",@"8000":@"正在处理中",@"4000":@"订单支付失败",@"6001":@"用户中途取消",@"6002":@"网络连接出错"};
    
    if([resultDic[@"resultStatus"] isEqualToString:@"9000"]){//支付成功
        [SNY_Toast showMsg:@"支付宝支付成功" WithDuration:2 WithStyle:showStyleWear];
        [self PaySuccesessPoP];
        
    }else {
        NSString *msg = [stateDict valueForKey:resultDic[@"resultStatus"]];
        [self alert:@"提示" msg:msg];
    }
    
}




#pragma mark -WX //微信支付


//微信支付
- (void)wxpayWithDict:(NSDictionary*)dict;
{

//        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
  
}



//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
    
    
}




-(void)PaySuccesessPoP
{
 
    [self.navigationController pushViewController:[JLPaySuccessViewController viewController] animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
