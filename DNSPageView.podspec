
Pod::Spec.new do |s|
  s.name             = 'DNSPageView'
  s.version          = '2.2.0'
  s.swift_version    = '5.0'
  s.summary          = 'DNSPageView is a lightweight, pure-Swift library.'
  s.description      = <<-DESC
                       DNSPageView is a lightweight, pure-Swift library for pageView.
                       DESC

  s.homepage         = 'https://github.com/Danie1s/DNSPageView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniels' => '176516837@qq.com' }
  s.source           = { :git => 'https://github.com/Danie1s/DNSPageView.git', :tag => s.version }

  s.ios.deployment_target = '9.0'

  s.source_files = 'DNSPageView/*.swift'
  s.requires_arc = true

end
