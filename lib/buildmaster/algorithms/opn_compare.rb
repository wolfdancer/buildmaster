module BuildMaster
  module Algorithms
    class OpnCompare
      def initialize(a, b)
        @a = a
        @b = b
        @m = a.size
        @n = b.size
      end

      def compare
        delta = @n - @m
        diff = SequenceDiff.new
        fp = NegativeIndexArray.new(@m + 1, @n + 1) {|index| EditAction.new(nil, nil, -1 - index, -1) }
        p = -1
        begin
          p = p + 1
          (-p..(delta - 1)).each do |k|
            fp[k] = snake(k, max(fp[k-1], fp[k+1]))
          end
          ((delta + p)..(delta - 1)).each do |k|
            fp[k] = snake(k, max(fp[k-1], fp[k+1]))
          end
          fp[delta] = snake(delta, max(fp[delta-1], fp[delta+1]))
        end until fp[delta].y == @n
        return diff
      end

      private
      def snake(k, edit)
        y = edit.y
        x = y - k
        snake = edit
        while (x < @m and y < @n and @a[x] == @b[y]) do
          x = x + 1
          y = y + 1
          snake = EditType::COPY.apply_to(snake)
        end
        snake
      end

      def max(fp1, fp2)
        if (fp1.y < fp2.y)
          EditType::DELETE.apply_to(fp2)
        else
          EditType::ADD.apply_to(fp1)
        end
      end
    end

    class NegativeIndexArray
      attr_reader :max_negative, :max_positive
      def initialize(max_negative, max_positive, &block)
        @max_negative = max_negative
        @max_positive = max_positive
        @array = Array.new(max_negative + max_positive + 1) {|index| block.call(index - max_negative)}
      end

      def [](index)
        @array[index + max_negative]
      end

      def []=(index, value)
        @array[index + max_negative] = value
      end
    end

    class SequenceDiff
      def edits
        []
      end
    end

    class EditAction
      attr_reader :type, :x, :y
      def initialize(last, type, x, y)
        @last = last
        @type = type
        @x = x
        @y = y
      end

      def inspect
        if @type
          "#{@type.name}(#@x, #@y) - )-" + @last.inspect
        else
          'nil'
        end
      end
    end

    class EditType
      attr_reader :name
      def initialize(name, deltx, delty)
        @name = name
        @deltx = deltx
        @delty = delty
      end

      def apply_to(edit_action)
        EditAction.new(edit_action, self, edit_action.x + @deltx, edit_action.y + @delty)
      end
      ADD = EditType.new('add', 0, 1)
      DELETE = EditType.new('delete', 1, 0)
      COPY = EditType.new('copy', 1, 1)
    end
  end
end