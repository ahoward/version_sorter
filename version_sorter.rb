module VersionSorter
  Pattern    = %r/(\d+)|([a-z])/io
  Normalized = Hash.new{|h,v| h[v] = v.scan(Pattern).map{|n,a| a ? a.unpack('c*') : [n.to_i]}}
  Sorted     = Hash.new{|h,l| h[l] = l.sort!{|a,b| Normalized[a] <=> Normalized[b]}}
  Rsorted    = Hash.new{|h,l| h[l] = Sorted[l].reverse} 

  def normalize(version)
    Normalized[version]
  end

  def sort(list)
    Sorted[list]
  end

  def rsort(list)
    Rsorted[list]
  end

  extend self
end

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

  require 'benchmark'
  versions = ARGF.read.split("\n")
  count = (ARGV.shift || 10).to_i
  Benchmark.bm(20) do |x|
    x.report("sort"){count.times{ VersionSorter.sort(versions) }}
    x.report("rsort"){count.times{ VersionSorter.rsort(versions) }}
  end
  puts
end
