
module Atig
  module IFilter
    class Tid
      def initialize(context)
        @opts = context.opts
        c = @opts.tid # expect: 0..15, true, "0,1"
        b = nil
        c, b = c.split(",", 2).map {|i| i.to_i } if c.respond_to? :split
        c = 10 unless (0 .. 15).include? c # 10: teal
        if (0 .. 15).include?(b)
          @format = "\003%.2d,%.2d[%%s]\017" % [c, b]
        else
          @format = "\003%.2d[%%s]\017"      % c
        end
      end

      def call(status)
        return status unless status.tid and @opts.tid
        status.merge :text => "#{status.text} #{@format % status.tid}"
      end
    end
  end
end