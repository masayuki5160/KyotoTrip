# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def google_utilites
  pod 'GoogleUtilities/AppDelegateSwizzler'
  pod 'GoogleUtilities/Environment'
  pod 'GoogleUtilities/ISASwizzler'
  pod 'GoogleUtilities/Logger'
  pod 'GoogleUtilities/MethodSwizzler'
  pod 'GoogleUtilities/NSData+zlib'
  pod 'GoogleUtilities/Network'
  pod 'GoogleUtilities/Reachability'
  pod 'GoogleUtilities/UserDefaults'
  pod 'GTMSessionFetcher'
end

target 'KyotoTrip' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  google_utilites

  # Pods for KyotoTrip
  pod 'Mapbox-iOS-SDK', '~> 5.7'
  pod 'RxSwift', '~> 5.1'
  pod 'RxCocoa', '~> 5.1'
  pod "SwiftyXMLParser", :git => 'https://github.com/yahoojapan/SwiftyXMLParser.git'
  pod 'Alamofire', '~> 4.9'
  pod 'Firebase/MLNLTranslate'
  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.14.0'
  pod 'Firebase/Analytics'
  pod 'FloatingPanel', '~> 1.7.4'
  target 'KyotoTripTests' do
    inherit! :search_paths
    google_utilites
    pod 'Firebase/MLNLTranslate'
  end
end
