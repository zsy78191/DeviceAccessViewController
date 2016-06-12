//
//  DeviceAccessViewController.m
//  DeviceAccessDemo
//
//  Created by 张超 on 15/12/17.
//  Copyright © 2015年 gerinn. All rights reserved.
//

#import "DeviceAccessViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>


NSString* const UIApplicationDidRegisterUserNotificationSettingsNotification = @"UIApplicationDidRegisterUserNotificationSettingsNotification";
NSString* const UesrDefaultNotificationAuthorizedKey = @"UesrDefaultNotificationAuthorizedKey";

@interface DeviceAccessViewController ()
{
    BOOL _notificationNeedSettings;
    BOOL _notificationAuthorizing;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_notification;
@property (weak, nonatomic) IBOutlet UIButton *button_notification;
@property (weak, nonatomic) IBOutlet UISwitch *switch_notification;
@property (weak, nonatomic) IBOutlet UILabel *label_notification;
@property (weak, nonatomic) IBOutlet UILabel *detial_notification;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_photo;
@property (weak, nonatomic) IBOutlet UIButton *button_photo;
@property (weak, nonatomic) IBOutlet UILabel *label_photo;
@property (weak, nonatomic) IBOutlet UILabel *detial_photo;
@property (weak, nonatomic) IBOutlet UISwitch *swich_photo;

@property (weak, nonatomic) IBOutlet UILabel *label_postion;
@property (weak, nonatomic) IBOutlet UILabel *detial_postition;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_position;
@property (weak, nonatomic) IBOutlet UIButton *button_position;

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation DeviceAccessViewController

- (void)viewDidLoad {
    
    self.authorizedColor = [UIColor colorWithRed:0.33 green:0.84 blue:0.41 alpha:1];
    self.unauthorizedColor = [UIColor colorWithRed:0.17 green:0.60 blue:0.94 alpha:1];
    self.settingColor = [UIColor orangeColor];
    
    [super viewDidLoad];
    
    _notificationNeedSettings = NO;
    _notificationAuthorizing = NO;
    self.indicator_notification.hidesWhenStopped = YES;
    self.indicator_photo.hidesWhenStopped = YES;
    self.indicator_position.hidesWhenStopped = YES;
    
    
    self.titleLable.text = [NSString stringWithFormat:NSLocalizedString(@"允许\"%@\"访问", nil),[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"]];
    
    [self loadConfig];
    [self loadPhotoConfig];
    [self loadPositition];
    [self setTarget];
    
    [self.settingButton setTitle:NSLocalizedString(@"设置", nil) forState:UIControlStateNormal];
    self.settingButton.tintColor = self.settingColor;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            [self loadConfig];
            [self loadPhotoConfig];
            [self loadPositition];
        });
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidRegisterUserNotificationSettingsNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        UIUserNotificationSettings* settings = note.userInfo[@"settings"];
        
        if (![[NSUserDefaults standardUserDefaults] valueForKey:UesrDefaultNotificationAuthorizedKey]) {
            [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:UesrDefaultNotificationAuthorizedKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            if (settings.types == UIUserNotificationTypeNone) {
                self.detial_notification.text = NSLocalizedString(@"您禁用了系统通知", nil);
                [self.button_notification setTitle:NSLocalizedString(@"设置", nil) forState:UIControlStateNormal];
                self.button_notification.tintColor = self.settingColor;
                _notificationNeedSettings = YES;
            }
            
        }
        else{
            if (settings.types == UIUserNotificationTypeNone) {
                
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您已禁用了\"通知\"服务", nil)
//                                                                               message:NSLocalizedString(@"请点击'设置'按钮开启", nil) preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"设置", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                }]];
//                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }]];
//                [self showViewController:alert sender:nil];
                
                self.detial_notification.text = NSLocalizedString(@"您禁用了系统通知", nil);
                [self.button_notification setTitle:NSLocalizedString(@"设置", nil) forState:UIControlStateNormal];
                self.button_notification.tintColor = self.settingColor;
                _notificationNeedSettings = YES;
                
            
            }
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            self.button_notification.alpha = 1;
            [self.indicator_notification stopAnimating];
        }];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidRegisterUserNotificationSettingsNotification object:nil];
}

- (void)loadConfig
{
    NSInteger type = [DAAccessManager notificationType];
//    self.switch_notification.on = type != 0;
    NSMutableString* detial = [[NSMutableString alloc] init];
    
    self.button_notification.enabled = YES;
    
    if (type & UIUserNotificationTypeBadge) {
        [detial appendFormat:NSLocalizedString(@"标记", nil)];
    }
    if (type & UIUserNotificationTypeSound) {
        if (detial.length > 0) {
            [detial appendFormat:NSLocalizedString(@"，", nil)];
        }
        [detial appendFormat:NSLocalizedString(@"声音", nil)];
    }
    if (type & UIUserNotificationTypeAlert) {
        if (detial.length > 0) {
            [detial appendFormat:NSLocalizedString(@"，", nil)];
        }
        [detial appendFormat:NSLocalizedString(@"横幅", nil)];
    }
    
    if (type == UIUserNotificationTypeNone) {
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:UesrDefaultNotificationAuthorizedKey]) {
            
            [detial appendFormat:NSLocalizedString(@"您禁用了系统通知", nil)];
            [self.button_notification setTitle:NSLocalizedString(@"设置", nil) forState:UIControlStateNormal];
            self.button_notification.tintColor = self.settingColor;
            _notificationNeedSettings = YES;
        }
        else
        {
            [detial appendFormat:NSLocalizedString(@"通知未授权", nil)];
            [self.button_notification setTitle:NSLocalizedString(@"授权", nil) forState:UIControlStateNormal];
            self.button_notification.tintColor = self.unauthorizedColor;
        }
        
    }
    else
    {
//        [detial appendFormat:NSLocalizedString(@"通知未授权", nil)];
            [self.button_notification setTitle:NSLocalizedString(@"已授权", nil) forState:UIControlStateNormal];
//            self.button_notification.enabled = NO;
            self.button_notification.tintColor =self.authorizedColor;
            _notificationNeedSettings = NO;
    }
    self.detial_notification.text = [detial copy];
    
}

- (void)loadPhotoConfig
{
    BOOL photo_on = NO;
    switch ([DAAccessManager photoAccesStatus]) {
        case PHAuthorizationStatusDenied:
        {
            self.detial_photo.text = NSLocalizedString(@"您禁用了系统照片", nil);
            [self.button_photo setTitle:NSLocalizedString(@"设置", nil) forState:UIControlStateNormal];
            self.button_photo.tintColor = self.settingColor;
            break;
        }
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusNotDetermined:
        {
            self.detial_photo.text = NSLocalizedString(@"系统照片未授权", nil);
            [self.button_photo setTitle:NSLocalizedString(@"授权", nil) forState:UIControlStateNormal];
            self.button_photo.tintColor = self.unauthorizedColor;
            break;
        }
        case PHAuthorizationStatusAuthorized:
        {
            self.detial_photo.text = NSLocalizedString(@"系统照片已授权", nil);
            [self.button_photo setTitle:NSLocalizedString(@"已授权", nil) forState:UIControlStateNormal];
            self.button_photo.tintColor =self.authorizedColor;
            photo_on = YES;
            break;
        }
        default:
            break;
    }
}

- (void)loadPositition
{
    
    switch ([DAAccessManager positionAuthorizationStatus]) {
        case kCLAuthorizationStatusDenied:
        {
            self.detial_postition.text = NSLocalizedString(@"您禁用了位置服务", nil);
            [self.button_position setTitle:NSLocalizedString(@"设置", nil) forState:UIControlStateNormal];
            self.button_position.tintColor = self.settingColor;
            break;
        }
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusNotDetermined:
        {
            self.detial_postition.text = NSLocalizedString(@"位置服务未授权", nil);
            [self.button_position setTitle:NSLocalizedString(@"授权", nil) forState:UIControlStateNormal];
            self.button_position.tintColor = self.unauthorizedColor;
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            self.detial_postition.text = NSLocalizedString(@"始终", nil);
            [self.button_position setTitle:NSLocalizedString(@"已授权", nil) forState:UIControlStateNormal];
            self.button_position.tintColor = self.authorizedColor;
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            self.detial_postition.text = NSLocalizedString(@"使用应用期间", nil);
            [self.button_position setTitle:NSLocalizedString(@"已授权", nil) forState:UIControlStateNormal];
            self.button_position.tintColor = self.authorizedColor;
            break;
        }
        default:
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setTarget
{
    [self.button_notification addTarget:self action:@selector(authorize:) forControlEvents:UIControlEventTouchUpInside];
    [self.button_photo addTarget:self action:@selector(authorize:) forControlEvents:UIControlEventTouchUpInside];
    [self.button_position addTarget:self action:@selector(authorize:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingButton addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)settings:(id)sender
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)authorize:(id)sender
{
    if (sender == self.button_notification) {
        if (_notificationNeedSettings) {
              if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
              }
        }
        else
        {
            if ([DAAccessManager notificationType] == UIUserNotificationTypeNone) {
                UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
                [DAAccessManager registNotificationSettings:type];
                [UIView animateWithDuration:0.01 animations:^{
                    self.button_notification.alpha = 0;
                    [self.indicator_notification startAnimating];
                }];
            }
            else
            {
                
            }
        }
    }
    else if (sender == self.button_photo)
    {
        if ([DAAccessManager photoAccesStatus] == PHAuthorizationStatusNotDetermined || [DAAccessManager photoAccesStatus] == PHAuthorizationStatusRestricted) {
            [UIView animateWithDuration:0.1 animations:^{
                self.button_photo.alpha = 0;
                [self.indicator_photo startAnimating];
            }];
            [DAAccessManager photoAuthorization:^(PHAuthorizationStatus status) {
                [self loadPhotoConfig];
                [UIView animateWithDuration:0.1 animations:^{
                    self.button_photo.alpha = 1;
                    [self.indicator_photo stopAnimating];
                }];
            }];
        }
        else if([DAAccessManager photoAccesStatus] == PHAuthorizationStatusDenied) {
              if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
              }
        }
        else
        {
            
        }
    }
    else if(sender == self.button_position)
    {
        if ([DAAccessManager positionAuthorizationStatus] == kCLAuthorizationStatusNotDetermined || [DAAccessManager positionAuthorizationStatus] == kCLAuthorizationStatusRestricted) {
            
            [DAAccessManager authorizedPosition:self.locationManager];
            
        }
        else if([DAAccessManager positionAuthorizationStatus] == kCLAuthorizationStatusDenied)
        {
              if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
              }
        }
        else{
            
        }
    }
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end


@implementation DAAccessManager

+ (BOOL)remoteNotificationEnabled
{
    UIApplication* application = [UIApplication sharedApplication];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIRemoteNotificationType type = [application enabledRemoteNotificationTypes];
        return type != UIRemoteNotificationTypeNone;
    }
    return [application isRegisteredForRemoteNotifications];
}

+ (void)registRemoteNotification
{
    UIApplication* application = [UIApplication sharedApplication];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge];
    }
    else{
        [application registerForRemoteNotifications];
    }
}

+ (BOOL)authorizedNotification
{
    UIApplication* application = [UIApplication sharedApplication];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIRemoteNotificationType type = [application enabledRemoteNotificationTypes];
        return type != UIRemoteNotificationTypeNone;
    }
    return ([application currentUserNotificationSettings]);
}

+ (UIUserNotificationType)notificationType
{
    UIApplication* application = [UIApplication sharedApplication];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIRemoteNotificationType type = [application enabledRemoteNotificationTypes];
        return (UIUserNotificationType)type;
    }
    return  [application currentUserNotificationSettings].types;
}

+ (void)registNotificationSettings:(UIUserNotificationType)type
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge];
    }
    else
    {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}

+ (void)unregistNotificationSettings
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

+ (PHAuthorizationStatus)photoAccesStatus
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        return (PHAuthorizationStatus)[ALAssetsLibrary authorizationStatus];
    }
    return [PHPhotoLibrary authorizationStatus];
}

+ (void)photoAuthorization:(void (^)(PHAuthorizationStatus status))result
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
//        [ALAssetsLibrary]
        [[[ALAssetsLibrary alloc] init] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (result) {
                result(3);
            }
        } failureBlock:^(NSError *error) {
            if (result) {
                result(1);
            }
        }];
    }
    else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (result) {
                result(status);
            }
        }];
    }
}

+ (CLAuthorizationStatus)positionAuthorizationStatus
{
    return [CLLocationManager authorizationStatus];
}

+ (void)authorizedPosition:(CLLocationManager *)manager
{
    if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
      [manager requestAlwaysAuthorization];
    }
    else{
        NSLog(@"requestAlwaysAuthorization -- 不支持8.0以下的系统");
    }
    
}

@end






