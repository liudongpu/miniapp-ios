# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

target 'miniapp-ios' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for miniapp-ios

  
  #begin 以下是react-native相关依赖#
  
  flagExist=File::exists?( "../node_modules/versions/0.59.10.a.md" )
  if !flagExist
      system 'rm -rf ../node_modules/'
      system 'git clone --branch v-0.59.10.a https://code.aliyun.com/uhutu-miniapp/miniapp-libs.git ../node_modules/'
  end
  # Your 'node_modules' directory is probably in the root of your project,
  # but if not, adjust the `:path` accordingly
  pod 'React', :path => '../node_modules/react-native', :subspecs => [
  'Core',
  'CxxBridge', # Include this for RN >= 0.47
  'DevSupport', # Include this to enable In-App Devmenu if RN >= 0.43
  'RCTText',
  'RCTNetwork',
  'RCTImage',
  'RCTLinkingIOS',
  'RCTWebSocket', # Needed for debugging
  'RCTAnimation', # Needed for FlatList and animations running on native UI thread
  # Add any other subspecs you want to use in your project
  ]
  # Explicitly include Yoga if you are using RN >= 0.42.0
  pod 'yoga', :path => '../node_modules/react-native/ReactCommon/yoga'
  
  # Third party deps podspec link
  pod 'DoubleConversion', :podspec => '../node_modules/react-native/third-party-podspecs/DoubleConversion.podspec'
  pod 'glog', :podspec => '../node_modules/react-native/third-party-podspecs/glog.podspec'
  pod 'Folly', :podspec => '../node_modules/react-native/third-party-podspecs/Folly.podspec'
  
  
  pod 'RNVectorIcons', :path => '../node_modules/react-native-vector-icons'
  
  #end react-nativei相关依赖完成#
  
  
  
  pod 'AFNetworking','~> 4.0.0'
  pod 'SSZipArchive'
  pod 'JSONModel'
  pod 'FDFullscreenPopGesture', '~> 1.1'
  pod 'MBProgressHUD'
end
