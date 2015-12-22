# DeviceAccessViewController


授权管理页面

![](https://raw.githubusercontent.com/zsy78191/DeviceAccessViewController/master/IMG_1620.PNG)

##使用方法

请在Application的代理文件中，引用`#import "DeviceAccessViewController.h"`

然后添加如下代码通知DeviceAccessViewController处理注册通知的回调。

```
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidRegisterUserNotificationSettingsNotification object:nil userInfo:@{@"settings":notificationSettings}];
}
```

就这些。


