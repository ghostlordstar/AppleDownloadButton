Pod::Spec.new do |s|

    s.name = 'AppleDownloadButton'
    s.version = '0.1.0'
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.summary = 'Revamped Download Button'
    s.homepage = 'https://github.com/ghostlordstar/AppleDownloadButton'
    # s.social_media_url = 'https://twitter.com/leocardz'
    s.authors = { "Hansen" => "heshanzhang@outlook.com" }
    s.source = { :git => "https://github.com/ghostlordstar/AppleDownloadButton.git", :tag => s.version.to_s }
    s.swift_version = "5.0"
    s.platforms     = { :ios => "9.0" }
    s.requires_arc = true
    s.source_files  = "Sources/**/*.swift"
end
