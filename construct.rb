require 'pathname'
require 'tmpdir'
require 'English'

module Construct

  def within_construct
    path = (Pathname(Dir.tmpdir)+"construct_container#{$PROCESS_ID}")
    begin
      path.mkpath
      yield(path)
    ensure
      path.rmtree
    end
  end
  
end
