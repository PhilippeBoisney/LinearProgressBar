Pod::Spec.new do |s|

    s.name              = "LinearProgressBar"
    s.version           = "1.0.1"
    s.summary           = "Linear Progress Bar for Swift"
    s.homepage          = "https://github.com/PhilippeBoisney/LinearProgressBar"
    s.author            = {
        "BOISNEY Philippe" => "phil.boisney(@)gmail.com"
    }
    s.license           = {
        :type => 'MIT',
        :file => 'LICENSE'
    }
    s.source            = {
        :git => "https://github.com/PhilippeBoisney/LinearProgressBar.git",
        :tag => "v1.0.1"
    }
    s.source_files      = "LinearProgressBar/LinearProgressBar.swift"
    s.frameworks = "UIKit"
    s.platform     = :ios, "7.0"

end
