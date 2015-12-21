//
//  DeviceAccessViewController.h
//  DeviceAccessDemo
//
//  Created by 张超 on 15/12/17.
//  Copyright © 2015年 gerinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
extern NSString* const UIApplicationDidRegisterUserNotificationSettingsNotification;

@interface DeviceAccessViewController : UIViewController

@property (nonatomic, strong) UIColor* authorizedColor;
@property (nonatomic, strong) UIColor* unauthorizedColor;
@property (nonatomic, strong) UIColor* settingColor;

@end

@interface DAAccessManager : NSObject
+ (BOOL)remoteNotificationEnabled;
+ (BOOL)authorizedNotification;
+ (UIUserNotificationType)notificationType;
+ (void)registNotificationSettings:(UIUserNotificationType)type;
+ (void)registRemoteNotification;
+ (PHAuthorizationStatus)photoAccesStatus;
+ (void)photoAuthorization:(void (^)(PHAuthorizationStatus status))result;
+ (CLAuthorizationStatus)positionAuthorizationStatus;
+ (void)authorizedPosition:(CLLocationManager*)manager;
@end