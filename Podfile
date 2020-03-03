platform :ios, '10.0'

using_bundler = defined? Bundler
unless using_bundler
    puts "\nPlease re-run using:".red
    puts "  bundle exec pod install\n\n"
    exit(1)
end

target 'VServer' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VServer
  pod 'SwiftLint'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'

  target 'VServerTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
  end

  target 'VServerUITests' do
    # Pods for testing
  end

end
