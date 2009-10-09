# stolen from http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/53779
module VersionSorter
  extend self

  def sort(list)
    list.sort_by {|x| normalize(x)}
  end

  def rsort(list)
    list.sort_by {|x| normalize(x)}.reverse
  end

private

  def normalize(version)
    version.to_s.scan(%r/\d+/o).map{|d| d.to_i}
  end
end

puts

if $0 == __FILE__
  require 'test/unit'

  class VersionSorterTest < Test::Unit::TestCase
    include VersionSorter

    def test_sorts_verisons_correctly
      versions = %w(1.0.9 1.0.10 2.0 3.1.4.2 1.0.9a)
      sorted_versions = %w( 1.0.9 1.0.9a 1.0.10 2.0 3.1.4.2 )

      assert_equal sorted_versions, sort(versions)
    end

    def test_reverse_sorts_verisons_correctly
      versions = %w(1.0.9 1.0.10 2.0 3.1.4.2 1.0.9a)
      sorted_versions = %w( 3.1.4.2 2.0 1.0.10 1.0.9a 1.0.9 )

      assert_equal sorted_versions, rsort(versions)
    end
  end

  if test(?e, 'tags.txt')
    require 'benchmark'
    versions = IO.read('tags.txt').split("\n")
    count = 10
    Benchmark.bm(20) do |x|
      x.report("sort")             { count.times { VersionSorter.sort(versions) } }
    end
    puts
  end

end
