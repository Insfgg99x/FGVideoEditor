Pod::Spec.new do |s|
s.name         = "FGVideoEditor"
s.version      = "1.2"
s.summary      = "FGVideoEditor convience video edit toolkit"
s.homepage     = "https://github.com/Insfgg99x/FGVideoEditor"
s.license      = "MIT"
s.authors      = { "CGPointZero" => "newbox0512@yahoo.com" }
s.source       = { :git => "https://github.com/Insfgg99x/FGVideoEditor.git", :tag => "1.2"}
s.frameworks   = 'Foundation','UIKit','AVFoundation','CoreMedia','Photos'
s.ios.deployment_target = '8.0'
s.source_files = 'FGVideoEditor/FGVideoEditor/*.swift'
s.requires_arc = true
s.dependency     'SnapKit'
s.dependency	 'FGHUD', '2.4'
s.dependency     'FGToolKit'
end

