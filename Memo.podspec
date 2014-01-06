Pod::Spec.new do |s|
  s.name = 'Memo'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Reactive extension to KVO'
  s.homepage = 'https://github.com/quirkyinc/memo'
  s.authors = { 'Jeremy Tregunna' => 'jeremy@tregunna.ca' }
  s.source = { :git => 'https://github.com/quirkyinc/memo.git' }
  s.requires_arc = true
  s.source_files = "Memo/*.{h,m}"
  s.ios.deployment_target = '6.0'
end
