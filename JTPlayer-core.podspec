Pod::Spec.new do |spec|
  # ――― 简介 ――― #
  spec.name         = "jtplayer-core"
  spec.version      = "0.0.1"
  spec.summary      = "简易播放器"
  spec.description  = <<-DESC
        需要导入IJKMediaFramework.framework
                   DESC
  # ―――  仓库地址  ―――――――― #
  spec.homepage     = "https://github.com/ZYiDa/jtplayer-core.git"
  # ―――  认证  ―――――――――― #
  spec.license      = "MIT"
  # ――― 作者介绍 ――――――――― #
  spec.author             = { "ZYiDa" => "xcodedeveloper@foxmail.com" }
  # ――― 平台配置 ――――――――― #
  spec.platform     = :ios,"9.0"
  # ――― 源码位置 ――――――――― #
  spec.source       = { :git => "https://github.com/ZYiDa/jtplayer-core.git", :tag => "#{spec.version}" }
  # ――― Source Code ――――――― #
  spec.source_files  = "JTPlayer-core/*.{h,m,a}","JTPlayer-core/Masonry/*.{h.m}"
  # ――― Project Linking 项目引用 ――――――― #
  spec.frameworks = "Foundation", "UIKit"
  # ――― Project Settings  设置――――――――― #
  spec.requires_arc = true
  # 添加spec.pod_target_xcconfig，执行pod lib lint --skip-import-validation 否则不支持i386和x86_64编译 ―――――――― #
#spec.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => '' }
end