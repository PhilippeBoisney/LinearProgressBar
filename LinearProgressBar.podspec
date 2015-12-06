Pod::Spec.new do |s|

    s.name              = "LinearProgressBar"
    s.version           = "1.0.0"
    s.summary           = "Linear Progress Bar for Swift"
    s.homepage          = "https://github.com/PhilippeBoisney/SimpleFloatingActionButton"
    s.author            = {
        "BOISNEY Philippe" => "phil.boisney(@)gmail.com"
    }
    s.license           = {
        :type => 'MIT',
        :file => 'LICENSE'
    }
    s.source            = {
        :git => "https://github.com/PhilippeBoisney/SimpleFloatingActionButton.git",
        :tag => "v1.0.0"
    }
    s.source_files      = "SimpleFloatingActionButton/SimpleFloatingActionButton.swift"
    s.frameworks = "UIKit"
    s.platform     = :ios, "8.0"

end
