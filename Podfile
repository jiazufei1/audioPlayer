source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
#Pod警告清除 https://www.jianshu.com/p/28203b143279
inhibit_all_warnings!
#项目中使用swift
use_frameworks!

target 'audioPlayer' do
  pod 'SwiftAudioPlayer'
#  pod 'CCVodSDK', '~> 4.11.1'
  
  
#
#pod 'MJRefresh', '~> 3.5.0'
#pod 'AFNetworking', '~> 4.0.1'
##pod 'YYKit', '~> 1.0.9'
#pod 'YYCache', '~> 1.0.4'
#pod 'YYText', '~> 1.0.7'
#pod 'MBProgressHUD', '~> 1.2.0'
#pod 'Masonry', '~> 1.1.0'
#pod 'SDWebImage', '~> 5.9.0'
#pod 'MJExtension', '~> 3.2.2'
#pod 'SSZipArchive', '~> 2.2.3'
##轮播图
#pod 'SDCycleScrollView','>= 1.80'
#
#
##阿里播放器更新到5.2.1 ,pod安装极慢且这种方式导入有坑，改用手动倒入https://www.jianshu.com/p/0b0afa9f0feb，
##集成文档https://help.aliyun.com/document_detail/124708.html?spm=a2c4g.11186623.2.18.5ef0a26eRchUxM
##pod 'AliPlayerSDK_iOS'
##pod 'CCVodSDK', '~> 4.11.1'
#
##tableView和collectionView无数据处理
#pod 'DZNEmptyDataSet', '~> 1.8.1'
##二维码扫描
##pod 'SGQRCode', '~> 3.0.1'
##开屏广告
##pod 'XHLaunchAd'
#
##极光推送
##pod 'JPush', '~> 3.3.6'
#
##网易云信,暂时项目中不需要
##pod 'NIMSDK_LITE', '~> 8.0.0'
##pod 'NIMKit', '~> 3.0.0'
#
##环形进度条
#pod 'ZZCircleProgress', '~> 0.3.1'
#pod "CTMediator", '~> 44'
#
##网易易盾，一键登录
##安装太慢，改手动添加
##pod 'NTESQuickPass', '~> 2.1.9'
##pod 'NTESVerifyCode', '~> 3.2.8'
#pod 'IQKeyboardManager'
#
#
#
#
#
##swift
#pod 'Alamofire', '~> 4.9.1'
##下载专用ios10
##pod 'Tiercel', '~> 3.2.0'
#pod 'SnapKit', '~> 4.2.0'
#pod 'Then', '~> 2.7.0'
#pod 'Reusable', '~> 4.1.1'
#pod 'Moya', '~> 13.0.1'
#pod 'HandyJSON', '~> 5.0.2'
#pod 'ReachabilitySwift', '~> 4.3.1'
##swift空集
##pod 'EmptyStateKit'
#
#
end

#防止三方库在debug模式下的TARGET警告https://stackoverflow.com/questions/54704207/the-ios-simulator-deployment-targets-is-set-to-7-0-but-the-range-of-supported-d
post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
end
