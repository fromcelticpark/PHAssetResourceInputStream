Pod::Spec.new do |s|
  s.name = 'PHAssetResourceInputStream'
  s.version = '0.0.1'
  s.license = { :type => 'MIT', :file => 'LICENSE.md' }
  s.summary = 'PHAssetResourceInputStream is an NSInputStream implementation library for Photos Framework'
  s.homepage = 'https://github.com/fromcelticpark/PHAssetResourceInputStream'
  s.author = { 'Aleksandr Dvornikov' => 'fromcelticpark@gmail.com' }
  s.source = { :git => 'https://github.com/fromcelticpark/PHAssetResourceInputStream.git', :tag => s.version.to_s }
  s.source_files = 'PHAssetResourceInputStream/*.swift'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.frameworks = 'Foundation', 'Photos'
  s.dependency 'POSInputStreamLibrary', '~> 2.3'  
  s.dependency 'Safe', '~> 1.2'
end