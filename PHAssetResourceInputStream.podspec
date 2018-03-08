Pod::Spec.new do |s|
  s.name = 'PHAssetResourceInputStream'
  s.version = '0.0.6'
  s.license = { :type => 'MIT', :file => 'LICENSE.md' }
  s.summary = 'PHAssetResourceInputStream is an input stream implementation library for assets from Photos Framework'
  s.homepage = 'https://github.com/fromcelticpark/PHAssetResourceInputStream'
  s.author = { 'Aleksandr Dvornikov' => 'fromcelticpark@gmail.com' }
  s.source = { :git => 'https://github.com/fromcelticpark/PHAssetResourceInputStream.git', :tag => s.version.to_s }
  s.source_files = 'PHAssetResourceInputStream/*.swift'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.frameworks = 'Foundation', 'Photos'
  s.dependency 'POSInputStreamLibrary', '~> 2.3'  
end