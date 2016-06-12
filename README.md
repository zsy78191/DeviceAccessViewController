# DeviceAccessViewController


授权管理页面

![](https://raw.githubusercontent.com/zsy78191/DeviceAccessViewController/master/IMG_1620.PNG)

##6.12更新autolayout，支持到7.0

7.0中不能使用跳转到Settings的功能。

##使用方法

随处可用

```
DeviceAccessViewController* dvc = [[DeviceAccessViewController alloc] initWithNibName:@"DeviceAccessViewController" bundle:[NSBundle mainBundle]];
[self.navigationController pushViewController:dvc animated:YES];
```

请在Application的代理文件中，引用`#import "DeviceAccessViewController.h"`
然后添加如下代码通知DeviceAccessViewController处理注册通知的回调。

```
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidRegisterUserNotificationSettingsNotification object:nil userInfo:@{@"settings":notificationSettings}];
}
```

就这些。


