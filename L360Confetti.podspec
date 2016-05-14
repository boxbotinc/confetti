Pod::Spec.new do |s|
  s.name         = "L360Confetti"
  s.version      = "1.1.3"
  s.summary      = "Delight your users with some confetti in your app!!"

  s.homepage     = "http://github.com/kevinnguy/confetti"
  s.license      = { :type => "Apache License, Version 2.0", :file => "iOS/LICENSE.md" }
  s.author       = "Kevin Nguy"
  s.source       = { :git => "https://github.com/kevinnguy/confetti.git", :tag => :master }

  s.platform     = :ios, "7.0"
  s.requires_arc = true
  s.framework    = "UIKit"
  s.source_files = "iOS/L360Confetti"
end
