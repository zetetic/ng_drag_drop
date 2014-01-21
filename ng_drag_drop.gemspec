require File.expand_path('../lib/ng_drag_drop/version',  __FILE__)

Gem::Specification.new do |s|
  s.name          = 'ng_drag_drop'
  s.version       = NgDragDrop::VERSION
  s.date          = '2014-01-20'
  s.summary       = 'AngularJS Drag and Drop Question Tool'
  s.description   = 'AngularJS Drag and Drop Question Tool'
  s.authors       = ['Tom Head']
  s.email         = 'tom.head@revolutionprep.com'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.homepage      = "http://github.com/RevolutionK12/ng_drag_drop"
  s.license       = 'MIT'
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'angularjs-rails', '>= 1.0.8'
  s.add_runtime_dependency 'raphael-rails', '~> 2.1.2'
end
