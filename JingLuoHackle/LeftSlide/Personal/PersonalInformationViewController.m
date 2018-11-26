//
//  PersonalInformationViewController.m
//  Voicediagno
//
//  Created by 王锋 on 14-6-13.
//  Copyright (c) 2014年 王锋. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "Global.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import <sys/utsname.h>
#import "ZHPickView.h"
#import "SonAccount.h"
#import "LoginViewControllerViewController.h"
#import "CustomNavigationController.h"
#import "UIButton+WebCache.h"
#import "PECropViewController.h"

#define currentMonth [currentMonthString integerValue]
@interface PersonalInformationViewController ()<ZHPickViewDelegate>
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic ,retain) SonAccount *son;
@property (nonatomic ,retain) UIView *dishiView;

@end

@implementation PersonalInformationViewController
@synthesize mobilestr;
@synthesize usernametr;
@synthesize Birthdaystr;
@synthesize genderstr;
@synthesize emailstr;
@synthesize idstr;
@synthesize regcodestr;
@synthesize datePicker;
@synthesize pRegistrationTF,pRegistrationnewTF,pyouxiangTF,pshenfenZTF;
@synthesize PersonInfoTableView=_PersonInfoTableView;
@synthesize customPicker=_customPicker;
@synthesize toolbarCancelDone=_toolbarCancelDone;
@synthesize pngFilePath;
@synthesize currentMonthString=_currentMonthString;
- (void)dealloc{
    [super dealloc];
    [_pickview release];
    [_son release];
    [_PersonInfoTableView release];
    [mobilestr release];
    [usernametr release];
    [Birthdaystr release];
    [genderstr release];
    [emailstr release];
    [idstr release];
    [regcodestr release];
    [datePicker release];
    [pRegistrationnewTF release];
    [pRegistrationTF release];
    [pyouxiangTF release];
    [pshenfenZTF release];
    [_customPicker release];
    [_toolbarCancelDone release];
    [_currentMonthString release];
    [IsYiBao release];
    [SelectTF release];
    [CertificatesType release];
    [SexStr release];
    [ivIDCard release];
    [TxImg release];
    [PersionInfoArray release];
    [Yh_TF release];
    [BirthDay_btn release];
    [TelephoneLb_Tf release];
    [Certificates_btn release];
    [AddressLb_Tf release];
    [Certificates_Number_Tf release];
    [yearArray release];
    [monthArray release];
    [DaysArray release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.labelText = @"加载中...";
    [progress_ show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    [progress_ release];
    progress_ = nil;
    
}

- (void)outLogin
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:LocalString(@"确认退出登录吗?") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *returnAct = [UIAlertAction actionWithTitle:LocalString(@"取消") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAct = [UIAlertAction actionWithTitle:LocalString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
        if (dicTmp) {
            [dicTmp setValue:@"0" forKey:@"ischeck"];
        }
        [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
        
        LoginViewControllerViewController *loginVC = [[LoginViewControllerViewController alloc] init];
        loginVC.passWordBox.text = @"";
        CustomNavigationController *nav=[[CustomNavigationController alloc]initWithRootViewController:loginVC];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        [nav release];
        [loginVC release];
        
    }];
    [alert addAction:returnAct];
    [alert addAction:sureAct];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void)RightAction
{
    if ([Certificates_btn.titleLabel.text isEqualToString:LocalString(@"请选择证件类型")]) {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"没有选择证件类型") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
    [av show];
    [av release];
    return;
    }
    
    if ([CertificatesType isEqualToString:@"idCard"]) {
        if (![UtilityFunc fitToChineseIDWithString:Certificates_Number_Tf.text]) {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"请填写正确的证件号码") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
            [av show];
            [av release];
            return;
        }
        
    }
    if ([BirthDay_btn.titleLabel.text isEqualToString:@""]||[BirthDay_btn.titleLabel.text isEqualToString:LocalString(@"请选择生日")]   ) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:LocalString(@"请选择生日") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/update.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:g_userInfo.token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    [request setPostValue:g_userInfo.uid forKey:@"id"];
    NSLog(@"str1:%@,str2:%@",self.UrlHttpImg,g_userInfo.memberImage);
    if(self.UrlHttpImg == nil || [self.UrlHttpImg isKindOfClass:[NSNull class]]){
        [request setPostValue:g_userInfo.memberImage forKey:@"memberImage"];
    }else{
        [request setPostValue:self.UrlHttpImg forKey:@"memberImage"];
    }
    [request setPostValue:SexStr forKey:@"gender"];
    [request setPostValue:Yh_TF.text forKey:@"name"];
    [request setPostValue:g_userInfo.UserName forKey:@"mobile"];
    [request setPostValue:TelephoneLb_Tf.text forKey:@"phone"];
    //[request setPostValue:self.genderstr forKey:@"nation"];
    //[request setPostValue:@"" forKey:@"isMarried"];
    [request addPostValue:g_userInfo.token forKey:@"token"];
    [request setPostValue:AddressLb_Tf.text forKey:@"address"];
    [request setPostValue:CertificatesType forKey:@"identityType"];
    [request setPostValue:Certificates_Number_Tf.text forKey:@"idNumber"];
    [request setPostValue:IsYiBao forKey:@"isMedicare"];
    if ([BirthDay_btn.titleLabel.text isEqualToString:LocalString(@"请选择生日")]) {
        BirthDay_btn.titleLabel.text=@"";
    }
    [request setPostValue:BirthDay_btn.titleLabel.text forKey:@"birthday"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestuserinfoError:)];
    [request setDidFinishSelector:@selector(requestuserinfoCompleted:)];
    [request startAsynchronous];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navTitleLabel.text = LocalString(@"个人信息");

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:LocalString(@"保存") forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(RightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CGRect tempRect= self.view.frame;
    tempRect.size.height-=45;
    self.view.frame=tempRect;
    _dishiView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_dishiView];
    
    
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    
    UILabel* lb1=[[UILabel alloc] init];
    lb1.frame=CGRectMake(0, 64, SCREEN_WIDTH, 1);
    lb1.backgroundColor=[UIColor clearColor];
    [_dishiView addSubview:lb1];
    [lb1 release];

    UILabel* TeleLb=[[UILabel alloc] init];
    TeleLb.frame=CGRectMake(20, 64+(47-21)/2, 120, 21);
    TeleLb.text=LocalString(@"手机号码");
    TeleLb.font=[UIFont systemFontOfSize:14];
    TeleLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    [_dishiView addSubview:TeleLb];
    [TeleLb release];
    
    UILabel* TelenameLb=[[UILabel alloc] init];
    TelenameLb.frame=CGRectMake(SCREEN_WIDTH-15-120, 64+(47-21)/2, 120, 21);
    if (g_userInfo.UserName== (id)[NSNull null]) {
        
    }
    else
    {
        TelenameLb.text=g_userInfo.UserName;
    }
    TelenameLb.textAlignment=2;
    TelenameLb.font=[UIFont systemFontOfSize:14];
    TelenameLb.textColor=[UtilityFunc colorWithHexString:@"#9b9b9b"];
    [_dishiView addSubview:TelenameLb];
    [TelenameLb release];

    
    UITableView *tableview=[[UITableView alloc]init];
    tableview.frame=CGRectMake(0,64+47, SCREEN_WIDTH,47*8+70);
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // tableview.separatorColor =[UIColor clearColor];
    tableview.backgroundColor=[UIColor clearColor];
    tableview.bounces = NO;
    //    self.MeTableview=tableview;
    _PersonInfoTableView=tableview;
    [_dishiView addSubview:tableview];
    [tableview release];
    
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(self.view.frame.size.width / 2 - 120,tableview.bottom+30, 240, 45);
    [finishButton setTitle:LocalString(@"退出登录") forState:UIControlStateNormal];
    [finishButton setBackgroundColor:UIColorFromHex(0x4FAEFE)];
    [finishButton addTarget:self action:@selector(outLogin) forControlEvents:UIControlEventTouchUpInside];
    finishButton.layer.cornerRadius = 5.0;
    [_dishiView addSubview:finishButton];
    
    PersionInfoArray=[NSMutableArray new];
    [PersionInfoArray addObject:LocalString(@"头像")];
    [PersionInfoArray addObject:LocalString(@"用户名")];
    [PersionInfoArray addObject:LocalString(@"性别")];
    [PersionInfoArray addObject:LocalString(@"出生日期")];
    [PersionInfoArray addObject:LocalString(@"居住地址")];
    [PersionInfoArray addObject:LocalString(@"固定电话")];
    [PersionInfoArray addObject:LocalString(@"证件类型")];
    [PersionInfoArray addObject:LocalString(@"证件号码")];
    [PersionInfoArray addObject:LocalString(@"保险")];

    ptCenterper=self.view.center;
    
    SexStr=@"male";
    IsYiBao=@"1";
}

- (IBAction)ivIDCardTapped:(id)sender {
    
    if (SelectTF!=nil) {
        [SelectTF resignFirstResponder];
        [self restoreView];
    }
    
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self cancelButtonTitle:LocalString(@"取消") destructiveButtonTitle:nil
                                                        otherButtonTitles:LocalString(@"拍照"), LocalString(@"选取照片"), nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
        [actionSheet release];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag==10006)
    {
        if (buttonIndex==0) {
            CertificatesType=@"idCard";
        }
        if (buttonIndex==1) {
            CertificatesType=@"officerCard";
        }
        if (buttonIndex==2) {
            CertificatesType=@"passport";
        }
        if (buttonIndex==3) {
            CertificatesType=@"elseCard";
        }
        if (buttonIndex==4) {
            return;
        }
        [Certificates_btn setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
    }
    else
    {
    if (buttonIndex == 0)
    {
        
       	//先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            
            UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
            //pickerContro = imagePicker;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = sourceType;
            const CGFloat cRed   = 232.0/255.0;
            const CGFloat cGreen = 149.0/255.0;
            const CGFloat cBlue  = 0.0/255.0;
            imagePicker.navigationBar.tintColor = [UIColor colorWithRed:cRed green:cGreen blue:cBlue alpha:1];
          //  [self.navigationController presentModalViewController:imagePicker animated:YES];
           
            [self presentViewController:imagePicker
                               animated:YES
                             completion:^(void){
                                 //Code
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
                             }];
            
            [imagePicker release];
        }
        
        
    }
    else if (buttonIndex == 1)
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        // pickerContro = imagePicker;
        const CGFloat cRed   = 232.0/255.0;
        const CGFloat cGreen = 149.0/255.0;
        const CGFloat cBlue  = 0.0/255.0;
        imagePicker.navigationBar.tintColor = [UIColor colorWithRed:cRed green:cGreen blue:cBlue alpha:1];
        imagePicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = sourceType;
        // [[[UIApplication sharedApplication] keyWindow] addSubview:imagePicker.view];
        //[self.navigationController presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker
                           animated:YES
                         completion:^(void){
                             //Code
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
                         }];
        [imagePicker release];
    }
    else
    {
    }
    }
}

#pragma mark -

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];

    [ivIDCard setImage: croppedImage forState:UIControlStateNormal];
    CGSize imagesize = croppedImage.size;
    imagesize.width = 300;
    imagesize.height = imagesize.width*croppedImage.size.height/croppedImage.size.width;
    if (croppedImage) {
        croppedImage = [GlobalCommon imageWithImage:croppedImage scaledToSize:imagesize];
        NSData *imageData = UIImageJPEGRepresentation(croppedImage, 0.3);
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.pngFilePath = [NSString stringWithFormat:@"%@/usertouxiang.png",docDir];
        
        [imageData writeToFile:self.pngFilePath atomically:YES];
        
        [self UpLoadImgHttp];
        
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
  
}

#pragma mark -
- (void)openEditorWithImage:(UIImage *)image
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    controller.cropView.aspectRatio = 1.0f;
    
    [self presentViewController:navigationController animated:YES completion:NULL];
    
}

#pragma mark -
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //[picker dismissModalViewControllerAnimated:YES];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditorWithImage:image];
    }];
    
    //[picker dismissViewControllerAnimated:YES completion:nil];
    //[ivIDCard setImage: [info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    
    //[picker dismissViewControllerAnimated:YES completion:nil];
    return;
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    self.pngFilePath = [NSString stringWithFormat:@"%@/usertouxiang.png",docDir];
//
//    //NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage])];
//    NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], .3)];
//    [data1 writeToFile:self.pngFilePath atomically:YES];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
  //  [self UpLoadImgHttp];
}

#pragma mark - 上传头像
-(void) UpLoadImgHttp
{
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/fileUpload/upload.jhtml",UrlPre];
    aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url1];
    [request addRequestHeader:@"token" value:g_userInfo.token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request addPostValue:@"image" forKey:@"fileType"];
    [request addPostValue:g_userInfo.token forKey:@"token"];
    [request setFile:self.pngFilePath forKey:@"file"];//可以上传图片
    [request setDidFailSelector:@selector(requestUpLoadError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestUpLoadCompleted:)];
    [request startAsynchronous];
    [request release];
}
- (void)requestUpLoadCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        self.UrlHttpImg=[dic objectForKey:@"data"];
    }
    else
    {
        [self hudWasHidden:nil];
    }
}
- (void)requestUpLoadError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"抱歉，请检查您的网络是否畅通") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
    [av show];
    [av release];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[picker dismissModalViewControllerAnimated:YES];
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 70;
        
    }
    float height=47;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return PersionInfoArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.000001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeMedicineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier]autorelease];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    if (indexPath.row==0) {
        
        UILabel* TxLb=[[UILabel alloc] init];
        TxLb.frame=CGRectMake(20.4, (70-21)/2, 80, 21);
        TxLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        TxLb.font=[UIFont systemFontOfSize:14];
        TxLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:TxLb];
        TxLb.backgroundColor=[UIColor whiteColor];
        [TxLb release];
        
        ivIDCard=[UIButton buttonWithType:UIButtonTypeCustom];
        ivIDCard.frame=CGRectMake(SCREEN_WIDTH-15-60, (70-60)/2, 60, 60);
        ivIDCard.layer.masksToBounds = YES;
        ivIDCard.layer.cornerRadius=ivIDCard.width/2.0;
        if(g_userInfo.memberImage != nil && ![g_userInfo.memberImage isKindOfClass:[NSNull class]]){
            [ivIDCard sd_setImageWithURL:[NSURL URLWithString:g_userInfo.memberImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"我的"]];
        }else{
            [ivIDCard setImage:[UIImage imageNamed:@"我的"] forState:UIControlStateNormal];
        }
        
        //[ivIDCard setImage:TxImg forState:UIControlStateNormal];
        [ivIDCard addTarget:self action:@selector(ivIDCardTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:ivIDCard];
        
    }
    else  if(indexPath.row==1){
        
        UILabel* YhLb=[[UILabel alloc] init];
        YhLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 80, 21);
        YhLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        YhLb.font=[UIFont systemFontOfSize:14];
        YhLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:YhLb];
        YhLb.backgroundColor=[UIColor whiteColor];
        [YhLb release];
        
        Yh_TF=[[UITextField alloc] init];
        Yh_TF.frame=CGRectMake(YhLb.frame.origin.x+YhLb.frame.size.width+5,  (cell.frame.size.height-21)/2, SCREEN_WIDTH-YhLb.frame.origin.x-YhLb.frame.size.width-5-20.5, 21);
        Yh_TF.placeholder=LocalString(@"请输入用户名");
        if (g_userInfo.Name== (id)[NSNull null]) {
            Yh_TF.text=@"";
        }else{
        Yh_TF.text=[NSString stringWithString:g_userInfo.Name];
        }
        [Yh_TF setValue:[UtilityFunc colorWithHexString:@"#333333"] forKeyPath:@"_placeholderLabel.textColor"];
        [Yh_TF setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        Yh_TF.returnKeyType=UIReturnKeyDone;
        Yh_TF.textAlignment = NSTextAlignmentRight;
        Yh_TF.delegate=self;
        [cell addSubview:Yh_TF];
        Yh_TF.font=[UIFont systemFontOfSize:14];
     
        
    }
    else if (indexPath.row==2)
    {
        
        
        UILabel* SexLb=[[UILabel alloc] init];
        SexLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 80, 21);
        SexLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        SexLb.font=[UIFont systemFontOfSize:14];
        SexLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:SexLb];
        SexLb.backgroundColor=[UIColor whiteColor];
        [SexLb release];
        
        NSArray *sexArr = @[LocalString(@"男"),LocalString(@"女")];
        for(NSInteger i=0;i<2;i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(ScreenWidth-135-20.5+65*i, (cell.frame.size.height-22)/2, 22, 22);
            [btn setImage:[UIImage imageNamed:@"leyaoNormal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"leyaoSelect"] forState:UIControlStateSelected];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(sexBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (g_userInfo.gender== (id)[NSNull null]){
                if(i == 0){
                    btn.selected = YES;
                }
            }if ([g_userInfo.gender isEqualToString:@"male"]){
                if(i == 0){
                    btn.selected = YES;
                }
            }
            else{
                if(i == 1){
                    btn.selected = YES;
                }
            }
            
            UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.right+5, btn.top, 50, btn.height)];
            sexLabel.font = [UIFont systemFontOfSize:16.0];
            sexLabel.textAlignment = NSTextAlignmentLeft;
            sexLabel.text = [sexArr objectAtIndex:i];
            [cell addSubview:btn];
            [cell addSubview:sexLabel];
        }
        
//        NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"男",@"女",nil];
//        UISegmentedControl* SegSex=[[UISegmentedControl alloc] initWithItems:segmentedArray];
//        SegSex.frame=CGRectMake(SCREEN_WIDTH-80-20.5, (cell.frame.size.height-26)/2, 80, 26);
//        [SegSex addTarget:self action:@selector(SegSexAction:) forControlEvents:UIControlEventValueChanged];
//        SegSex.segmentedControlStyle = UISegmentedControlStyleBordered;//设置样
//        SegSex.tintColor = [UtilityFunc colorWithHexString:@"#5eb4fd"];
//        [cell addSubview:SegSex];
//
//        if (g_userInfo.gender== (id)[NSNull null]) {
//
//             SegSex.selectedSegmentIndex=0;
//        }
//        else{
//        if ([g_userInfo.gender isEqualToString:@"male"]) {
//            SegSex.selectedSegmentIndex=0;
//        }
//        else
//        {
//             SegSex.selectedSegmentIndex=1;
//        }
//        }
//        [SegSex release];
    }
    else if (indexPath.row==3)
    {
        UILabel* BirthDayLb=[[UILabel alloc] init];
        BirthDayLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 100, 21);
        BirthDayLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        BirthDayLb.font=[UIFont systemFontOfSize:14];
        BirthDayLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:BirthDayLb];
        BirthDayLb.backgroundColor=[UIColor whiteColor];
        [BirthDayLb release];
        
        BirthDay_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        BirthDay_btn.frame=CGRectMake(BirthDayLb.frame.origin.x+BirthDayLb.frame.size.width+5,  (cell.frame.size.height-21)/2, SCREEN_WIDTH-BirthDayLb.frame.origin.x-BirthDayLb.frame.size.width-5-20.5, 21);
        BirthDay_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        BirthDay_btn.titleLabel.textAlignment = NSTextAlignmentRight;
        if (g_userInfo.birthday== (id)[NSNull null]) {
            
             [BirthDay_btn setTitle:LocalString(@"请选择生日") forState:UIControlStateNormal];
            
        }
        else
        {
            [BirthDay_btn setTitle:g_userInfo.birthday forState:UIControlStateNormal];
            
        }
        
      //  [BirthDay_btn setTitle:g_userInfo.birthday forState:UIControlStateNormal];
        [BirthDay_btn addTarget:self action:@selector(BirthDayActive:) forControlEvents:UIControlEventTouchUpInside];
        [BirthDay_btn setTitleColor:[UtilityFunc colorWithHexString:@"#333333"] forState:UIControlStateNormal];
         BirthDay_btn.titleLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:BirthDay_btn];
    }
    else if (indexPath.row==4)
    {
        UILabel* AddressLb=[[UILabel alloc] init];
        AddressLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 150, 21);
        AddressLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        AddressLb.font=[UIFont systemFontOfSize:14];
        AddressLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:AddressLb];
        AddressLb.backgroundColor=[UIColor whiteColor];
        [AddressLb release];
        
        AddressLb_Tf=[[UITextField alloc] init];
        AddressLb_Tf.frame=CGRectMake(AddressLb.frame.origin.x+AddressLb.frame.size.width+5,  (cell.frame.size.height-21)/2, SCREEN_WIDTH-AddressLb.frame.origin.x-AddressLb.frame.size.width-5-20.5, 21);
        AddressLb_Tf.delegate=self;
        AddressLb_Tf.placeholder=LocalString(@"请输入居住地址");
        AddressLb_Tf.textAlignment = NSTextAlignmentRight;
        if (g_userInfo.address== (id)[NSNull null]) {
           
        }
        else
        {
             AddressLb_Tf.text=g_userInfo.address;
        }
        AddressLb_Tf.returnKeyType=UIReturnKeyDone;
        [AddressLb_Tf setValue:[UtilityFunc colorWithHexString:@"#333333"] forKeyPath:@"_placeholderLabel.textColor"];
        [AddressLb_Tf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        
        [cell addSubview:AddressLb_Tf];
        AddressLb_Tf.font=[UIFont systemFontOfSize:14];
        [AddressLb_Tf release];
        
        
        
    }
    else if (indexPath.row==5)
    {
        UILabel* TelephoneLb=[[UILabel alloc] init];
        TelephoneLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 200, 21);
        TelephoneLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        TelephoneLb.font=[UIFont systemFontOfSize:14];
        TelephoneLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:TelephoneLb];
        TelephoneLb.backgroundColor=[UIColor whiteColor];
        [TelephoneLb release];
        
        TelephoneLb_Tf=[[UITextField alloc] init];
        TelephoneLb_Tf.frame=CGRectMake(TelephoneLb.frame.origin.x+TelephoneLb.frame.size.width+5,  (cell.frame.size.height-21)/2, SCREEN_WIDTH-TelephoneLb.frame.origin.x-TelephoneLb.frame.size.width-5-20.5, 21);
        TelephoneLb_Tf.returnKeyType=UIReturnKeyDone;
        TelephoneLb_Tf.delegate=self;
        TelephoneLb_Tf.placeholder=LocalString(@"请输入固定电话");
        TelephoneLb_Tf.textAlignment = NSTextAlignmentRight;
        TelephoneLb_Tf.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        [TelephoneLb_Tf setValue:[UtilityFunc colorWithHexString:@"#333333"] forKeyPath:@"_placeholderLabel.textColor"];
        [TelephoneLb_Tf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        if (g_userInfo.phone== (id)[NSNull null]) {
            
        }
        else{
             TelephoneLb_Tf.text=g_userInfo.phone;
            
        }
        TelephoneLb_Tf.font=[UIFont systemFontOfSize:14];
        [cell addSubview:TelephoneLb_Tf];
        [TelephoneLb_Tf release];

    }
    else if (indexPath.row==6)
    {
        UILabel* CertificatesLb=[[UILabel alloc] init];
        CertificatesLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 200, 21);
        CertificatesLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        CertificatesLb.font=[UIFont systemFontOfSize:14];
        CertificatesLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:CertificatesLb];
        CertificatesLb.backgroundColor=[UIColor whiteColor];
        [CertificatesLb release];
        
        Certificates_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        Certificates_btn.frame=CGRectMake(CertificatesLb.frame.origin.x+CertificatesLb.frame.size.width+5,  (cell.frame.size.height-21)/2, SCREEN_WIDTH-CertificatesLb.frame.origin.x-CertificatesLb.frame.size.width-5-20.5, 21);
        [cell addSubview:Certificates_btn];
        Certificates_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [Certificates_btn setTitle:LocalString(@"请选择证件类型") forState:UIControlStateNormal];
        [Certificates_btn setTitleColor:[UtilityFunc colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [Certificates_btn addTarget:self action:@selector(CertificatesAactive:) forControlEvents:UIControlEventTouchUpInside];
         Certificates_btn.titleLabel.font=[UIFont systemFontOfSize:14];
        
        if (g_userInfo.identityType == (id)[NSNull null]) {
            [Certificates_btn setTitle:LocalString(@"请选择证件类型") forState:UIControlStateNormal];
        }else{
        if ([g_userInfo.identityType isEqualToString:@"idCard"]) {
            [Certificates_btn setTitle:LocalString(@"身份证") forState:UIControlStateNormal];
        }else if ([g_userInfo.identityType isEqualToString:@"officerCard"])
        {
            [Certificates_btn setTitle:LocalString(@"军官证") forState:UIControlStateNormal];
        }
        else if ([g_userInfo.identityType isEqualToString:@"passport"])
        {
             [Certificates_btn setTitle:LocalString(@"护照") forState:UIControlStateNormal];
        }
        else{
            [Certificates_btn setTitle:LocalString(@"其他") forState:UIControlStateNormal];
        }
        }
        }
    else if (indexPath.row==7)
    {
        UILabel* Certificates_NumberLb=[[UILabel alloc] init];
        Certificates_NumberLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 150, 21);
        Certificates_NumberLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        Certificates_NumberLb.font=[UIFont systemFontOfSize:14];
        Certificates_NumberLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:Certificates_NumberLb];
        Certificates_NumberLb.backgroundColor=[UIColor whiteColor];
        [Certificates_NumberLb release];
        
        Certificates_Number_Tf=[[UITextField alloc] init];
        Certificates_Number_Tf.frame=CGRectMake(Certificates_NumberLb.frame.origin.x+Certificates_NumberLb.frame.size.width+5,  (cell.frame.size.height-21)/2, SCREEN_WIDTH-Certificates_NumberLb.frame.origin.x-Certificates_NumberLb.frame.size.width-5-20.5, 21);
        Certificates_Number_Tf.delegate=self;
        Certificates_Number_Tf.returnKeyType=UIReturnKeyDone;
        Certificates_Number_Tf.placeholder=LocalString(@"请输入证件号码");
        Certificates_Number_Tf.textAlignment = NSTextAlignmentRight;
        if ([g_userInfo.idNumber isKindOfClass:[NSNull class]]||[g_userInfo.idNumber isEqual:[NSNull null]]||g_userInfo.idNumber == nil) {
           
        }else{
            NSLog(@"idnumber:%@",g_userInfo.idNumber);
            Certificates_Number_Tf.text=[NSString stringWithString:g_userInfo.idNumber];
        }
        [Certificates_Number_Tf setValue:[UtilityFunc colorWithHexString:@"#333333"] forKeyPath:@"_placeholderLabel.textColor"];
        [Certificates_Number_Tf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [cell addSubview:Certificates_Number_Tf];
        Certificates_Number_Tf.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        Certificates_Number_Tf.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        Certificates_Number_Tf.font=[UIFont systemFontOfSize:14];
        [Certificates_Number_Tf release];
        
    }
    else if (indexPath.row==8)
    {
        UILabel* SexLb=[[UILabel alloc] init];
        SexLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 260, 21);
        SexLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        SexLb.font=[UIFont systemFontOfSize:14];
        SexLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:SexLb];
        SexLb.backgroundColor=[UIColor whiteColor];
        [SexLb release];
        
        NSArray *sexArr = @[LocalString(@"有"),LocalString(@"无")];
        for(NSInteger i=0;i<2;i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(ScreenWidth-100-20.5+55*i, (cell.frame.size.height-22)/2, 22, 22);
            [btn setImage:[UIImage imageNamed:@"leyaoNormal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"leyaoSelect"] forState:UIControlStateSelected];
            btn.tag = 2000+i;
            [btn addTarget:self action:@selector(MedicareAction:) forControlEvents:UIControlEventTouchUpInside];
            if(g_userInfo.isMedicare == (id)[NSNull null]){
                if(i==0){
                    btn.selected = YES;
                }
            }else{
                if([g_userInfo.isMedicare boolValue]){
                    if(i==0){
                        btn.selected = YES;
                    }
                }else{
                    if(i==1){
                        btn.selected = YES;
                    }
                }
            }
            
            
            UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.right-5, btn.top, 40, btn.height)];
            sexLabel.font = [UIFont systemFontOfSize:16.0];
            sexLabel.textAlignment = NSTextAlignmentCenter;
            sexLabel.text = [sexArr objectAtIndex:i];
            [cell addSubview:btn];
            [cell addSubview:sexLabel];
        }
        
//        NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"有",@"无",nil];
//        UISegmentedControl* YiHunSex=[[UISegmentedControl alloc] initWithItems:segmentedArray];
//        YiHunSex.frame=CGRectMake(SCREEN_WIDTH-80-20.5, (cell.frame.size.height-26)/2, 80, 26);
//        if (g_userInfo.isMedicare == (id)[NSNull null])
//        {
//             YiHunSex.selectedSegmentIndex=0;
//        }
//        else{
//        if ([g_userInfo.isMedicare boolValue])
//
//        {
//            YiHunSex.selectedSegmentIndex=0;
//        }
//        else
//        {
//            YiHunSex.selectedSegmentIndex=1;
//        }
//        }
//
//        [YiHunSex addTarget:self action:@selector(YiHunSexAction:) forControlEvents:UIControlEventValueChanged];
//        YiHunSex.segmentedControlStyle = UISegmentedControlStyleBordered;//设置样
//
//        YiHunSex.tintColor = [UtilityFunc colorWithHexString:@"#5eb4fd"];
//        [cell addSubview:YiHunSex];
//                [YiHunSex release];
    }
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    if(indexPath.row == 0){
        lineImageV.frame = CGRectMake(0, 69, ScreenWidth, 1);
    }else{
        lineImageV.frame = CGRectMake(0, 46, ScreenWidth, 1);
    }
    lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
    lineImageV.alpha = 0.5;
    [cell addSubview:lineImageV];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

- (void)sexBtnAction:(UIButton *)button
{
    UITableViewCell *cell = [self.PersonInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    UIButton *btn1 = [cell viewWithTag:1000];
    UIButton *btn2 = [cell viewWithTag:1001];
    
    if(button.tag == 1000){
        if(button.selected){
            return;
        }else{
            button.selected = YES;
            btn2.selected = NO;
        }
        SexStr = @"male";
    }else{
        if(button.selected){
            return;
        }else{
            button.selected = YES;
            btn1.selected = NO;
        }
        SexStr = @"female";
    }
}

- (void)MedicareAction:(UIButton *)button
{
    UITableViewCell *cell = [self.PersonInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    
    UIButton *btn1 = [cell viewWithTag:2000];
    UIButton *btn2 = [cell viewWithTag:2001];
    
    if(button.tag == 2000){
        if(button.selected){
            return;
        }else{
            button.selected = YES;
            btn2.selected = NO;
        }
        IsYiBao = @"1";
    }else{
        if(button.selected){
            return;
        }else{
            button.selected = YES;
            btn1.selected = NO;
        }
        IsYiBao = @"0";
    }
}

-(void)SegSexAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
        {
            SexStr=@"male";
            break;
        }
        case 1:
        {
            SexStr=@"female";
            break;
        }
        default:
            break;
    }
    
    //NSLog(@"Seg.selectedSegmentIndex:%ld",Index);
}
-(void)YiHunSexAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
        {
           
            IsYiBao=@"1";
            break;
        }
        case 1:
        {
           
            IsYiBao=@"0";
            break;
        }
        default:
            break;
    }
    
   // NSLog(@"Seg.selectedSegmentIndex:%ld",Index);
}
-(void)AcceptAction:(id)sender
{
    
    if ([Certificates_btn.titleLabel.text isEqualToString:LocalString(@"请选择证件类型")]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"没有选择证件类型") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    
    if ([CertificatesType isEqualToString:@"idCard"]) {
        if (![UtilityFunc fitToChineseIDWithString:Certificates_Number_Tf.text]) {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"请填写正确的证件号码") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
            [av show];
            [av release];
            return;
        }

    }
    
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/update.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:g_userInfo.token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    [request setPostValue:g_userInfo.uid forKey:@"id"];
    
    [request setPostValue:self.UrlHttpImg forKey:@"memberImage"];
    [request setPostValue:SexStr forKey:@"gender"];
    [request setPostValue:Yh_TF.text forKey:@"name"];
    [request setPostValue:g_userInfo.UserName forKey:@"mobile"];
    [request setPostValue:TelephoneLb_Tf.text forKey:@"phone"];
    //[request setPostValue:self.genderstr forKey:@"nation"];
    //[request setPostValue:@"" forKey:@"isMarried"];
     [request addPostValue:g_userInfo.token forKey:@"token"];
    [request setPostValue:AddressLb_Tf.text forKey:@"address"];
    [request setPostValue:CertificatesType forKey:@"identityType"];
    [request setPostValue:Certificates_Number_Tf.text forKey:@"idNumber"];
    [request setPostValue:IsYiBao forKey:@"isMedicare"];
    if ([BirthDay_btn.titleLabel.text isEqualToString:LocalString(@"请选择生日")]) {
        BirthDay_btn.titleLabel.text=@"";
    }
    [request setPostValue:BirthDay_btn.titleLabel.text forKey:@"birthday"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestuserinfoError:)];
    [request setDidFinishSelector:@selector(requestuserinfoCompleted:)];
    [request startAsynchronous];
}
-(void)CertificatesAactive:(id)sender
{
    if (SelectTF!=nil) {
        [SelectTF resignFirstResponder];
        [self restoreView];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:LocalString(@"取消") destructiveButtonTitle:nil
                                                    otherButtonTitles:LocalString(@"身份证"), LocalString(@"军官证"),LocalString(@"护照"),LocalString(@"其它") ,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag=10006;
    
    actionSheet.title=LocalString(@"证件类型");
    //actionSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]]; // show from our table view (pops up in the middle of the table)
    [actionSheet release];

}
-(void) BirthDayActive:(id)sender

{
    if (SelectTF!=nil) {
        [SelectTF resignFirstResponder];
        [self restoreView];
    }
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
    _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    _pickview.delegate=self;
    [_pickview show];

}
- (void)requestuserinfoCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"123213213213213213213213dic==%@",reqstr);
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    
    if ([status intValue]==100) {
//        SonAccount *son = [[SonAccount alloc]init];
//        son.array = [NSMutableArray arrayWithArray:[dic objectForKey:@"data"]];
        NSDictionary *resultDic = [dic objectForKey:@"data"];
        g_userInfo.Name=Yh_TF.text;
        g_userInfo.gender=SexStr;
        g_userInfo.birthday=BirthDay_btn.titleLabel.text;
        g_userInfo.address=AddressLb_Tf.text;
        g_userInfo.phone=TelephoneLb_Tf.text;
        g_userInfo.identityType=CertificatesType;
        g_userInfo.idNumber=Certificates_Number_Tf.text;
        g_userInfo.isMedicare=IsYiBao;
        g_userInfo.memberImage=[resultDic objectForKey:@"memberImage"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"信息更新成功") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        av.tag=10007;
        [av release];
        
    }
    else if ([status intValue]==44)
    {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"登录超时，请重新登录") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        av.tag = 100008;
        [av show];
        [av release];
    }else{
        NSString *str = [dic objectForKey:@"data"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:str delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        //av.tag = 100008;
        [av show];
        [av release];
    }

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==10007)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag==100008)
    {
        LoginViewControllerViewController *loginVC = [[LoginViewControllerViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)requestuserinfoError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"抱歉，请检查您的网络是否畅通") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
    [av show];
    [av release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    SelectTF=textField;
    if (textField==Yh_TF) {
        return;
    }
    [ self resizeViewForInput:nil ];
   
}
-(void)resizeViewForInput:(id)sender
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    _dishiView.center = CGPointMake(ptCenterper.x, ptCenterper.y-150);
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self restoreView];
    return YES;
}
-(void)restoreView
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    _dishiView.center = CGPointMake(ptCenterper.x, ptCenterper.y + 20);
    [UIView commitAnimations];
}
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    NSLog(@"ddfdfd=%@",resultString);
    [BirthDay_btn setTitle:resultString forState:UIControlStateNormal];
   // UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:_indexPath];
    //cell.detailTextLabel.text=resultString;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_pickview remove];
}

- (void)viewWillDisappear:(BOOL)animated{
    [_pickview remove];
}
@end
