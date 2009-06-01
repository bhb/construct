require 'test_helper'
require 'tmpdir'
require 'English'
require 'construct'

class ConstructTest < Test::Unit::TestCase
  include Construct

  # add boolean flag to determine whether to switch into construct dir or not

  testing "creating a construct container" do

    test "should exist" do
      within_construct do
        assert File.directory?(File.join(Dir.tmpdir, "construct_container#{$PROCESS_ID}"))
      end
    end

    test "should yield to its block" do
      sensor = "no yield"
      within_construct do
        sensor = "yielded"
      end
      assert_equal "yielded", sensor
    end

    test "block argument should be container directory Pathname" do
      within_construct do |container_path|
        assert_equal((Pathname(Dir.tmpdir)+"construct_container#{$PROCESS_ID}"), container_path)
      end
    end

    test "should not exist afterwards" do
      path = nil
      within_construct do |container_path|
        path = container_path
      end
      assert !path.exist?
    end

    test "should remove entire tree afterwards" do
      path = nil
      within_construct do |container_path|
        path = container_path
        (container_path + "foo").mkdir
      end
      assert !path.exist?
    end

    test "should remove dir if block raises exception" do
      path = nil
      begin
        within_construct do |container_path|
          path = container_path
          raise "something bad happens here"
        end 
      rescue
      end
      assert !path.exist?
    end

    test "should not capture exceptions raised in block" do
    end
    
  end

end
