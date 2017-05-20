Pod::Spec.new do |s|

  s.license      = "MIT"
  s.author       = { "qqc" => "20599378@qq.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc  = true

  s.name         = "QqcTextView"
  s.version      = "1.0.14"
  s.summary      = "QqcTextView"
  s.homepage     = "https://github.com/xukiki/QqcTextView"
  s.source       = { :git => "https://github.com/xukiki/QqcTextView.git", :tag => "#{s.version}" }
  
  s.source_files  = ["QqcTextView/*.{h,m}"]
  s.dependency "QqcColorDef"
  s.dependency "QqcComFuncDef"
  
end
