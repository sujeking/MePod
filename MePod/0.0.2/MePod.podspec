#
#  Be sure to run `pod spec lint MePod.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "MePod"
  s.version      = "0.0.2"
  s.summary      = 'HXStoreUtilities, a library of app. Common classes.'

  s.homepage     = "https://github.com/sujeking/MePod"
 
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "sujeking" => "email@address.com" }
  s.requires_arc = true
  
  s.platform     = :ios, "7.0"


  s.source       = { :git => "https://github.com/sujeking/MePod.git", :tag => "0.0.2", :submodules => true }


# ----------------------------------------------------------------

  s.subspec 'HXSPopView' do |ss|
    ss.source_files = 'MyLib/HXSPopView/*.{h,m}' #//代码
    ss.resource_bundles = {
      'HXSPopView' => 'MyLib/HXSPopView/Resouces/*'  #//xib 图片 等等
    }
  end

end
