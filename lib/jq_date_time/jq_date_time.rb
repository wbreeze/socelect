# modification of actionpack-3.0.3/lib/action_view/helpers/date_helper.rb
# supports use of jQuery datepicker for date selection
# aquires time in local time of client machine translated to/from UTC for the server

# Extension for ActionView::Base
# ActionView::Base.send :include, JQDateTimeHelper
module JQDateTimeHelper

  # Returns a jQuery date picker and set of select tags (one for hour, minute, and optionally second) pre-selected for accessing a
  # specified datetime-based attribute (identified by +method+) on an object assigned to the template (identified
  # by +object+).
  #
  # It is possible to override the order of the selectors using the <tt>:order</tt> option with
  # an array of symbols <tt>:date</tt>, <tt>:hour</tt>, <tt>:minute</tt> and <tt>:second</tt> in the desired order. 
  # If you do not supply a symbol, this helper will not render a selector for that element.
  # The default is :order => [ :date, :hour, :minute ]
  # You can append seconds with option <tt>:include_seconds => true</tt> or include :second in the order.
  #
  # You can add <tt>:datetime_separator</tt> to the +options+ to render between the date picker and the time selects.  
  # The default is a space.
  #
  # You can add <tt>:time_separator</tt> keys to the +options+ to render between the hour, minute, and second selects.
  # The default is a colon separated by spaces.
  #
  # If anything is passed in the html_options hash it will be applied to every datepicker input text and select tags in the set.
  #
  # ==== Examples
  #   # Generates a datetime select that, when POSTed, will be stored in the post variable in the written_on
  #   # attribute
  #   datetime_select("post", "written_on")
  #
  #   # Generates a datetime select with a default value of 3 days from the current time that, when POSTed, will
  #   # be stored in the trip variable in the departing attribute.
  #   datetime_select("trip", "departing", :default => 3.days.from_now)
  #
  #   # Generates a datetime select with a custom prompt. Use :prompt=>true for generic prompts.
  #   datetime_select("post", "written_on", :prompt => {:day => 'Choose day', :month => 'Choose month', :year => 'Choose year'})
  #   datetime_select("post", "written_on", :prompt => {:hour => true}) # generic prompt for hours
  #   datetime_select("post", "written_on", :prompt => true) # generic prompts for all
  #
  # The selects are prepared for multi-parameter assignment to an Active Record object.
  # Time selection occurs in the browser time zone, is posted to the server as UTC
  #
  def jq_datetime_select(object_name, method, options = {}, html_options = {})
    itag = ::ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object))
    itag.to_jq_datetime_select_tag(options, html_options)
  end

  class JQDateTimeSelector
    include ::ActionView::Helpers::TagHelper
    include ::ActionView::Helpers::JavaScriptHelper

    DEFAULT_PREFIX = 'date'.freeze
    POSITION = {
      :year => 1, :month => 2, :day => 3, :hour => 4, :minute => 5,
      :second => 6, :min => 5, :sec => 6
    }.freeze

    def initialize(datetime, options = {}, html_options = {})
      @options      = options.dup
      @html_options = html_options.dup
      @datetime     = datetime
      @options[:datetime_separator] ||= ' &mdash; '
      @options[:time_separator]     ||= ' : '
    end

    def select_datetime
      order = @options[:order] || [:date, :hour, :minute]
      order << :second if @options[:include_seconds]
      result = "\n"
      result << build_hidden_inputs()
      result << build_auxiliary(:time_offset, 'hidden', true)
      result << build_selects_from_types(order)
      result << build_time_zone_offset
      result << build_script_support
    end

    private
      DATEFIELDS = %w{ sec min hour day month year }.freeze
      DATEFIELDS.each do |method|
        define_method(method) do
          @datetime.kind_of?(Fixnum) ? @datetime : @datetime.send(method) if @datetime
        end
      end

      def select_date
        build_date_select()
      end

      def select_second
        build_options_and_select(:time_sec, sec, :step => @options[:second_step])
      end

      def select_minute
        build_options_and_select(:time_min, min, :step => @options[:minute_step])
      end

      def select_hour
        build_options_and_select(:time_hour, hour, :end => 23, :step => @options[:hour_step])
      end

      # Build full select tag from date type and options
      def build_options_and_select(type, selected, options = {})
        build_select(type, build_options(selected, options))
      end

      # Build select option html from date value and options
      #  build_options(15, :start => 1, :end => 31)
      #  => "<option value="1">1</option>
      #      <option value=\"2\">2</option>
      #      <option value=\"3\">3</option>..."
      def build_options(selected, options = {})
        start         = options.delete(:start) || 0
        stop          = options.delete(:end) || 59
        step          = options.delete(:step) || 1

        select_options = []
        start.step(stop, step) do |i|
          value = sprintf("%02d", i)
          tag_options = { :value => value }
          select_options << content_tag(:option, value, tag_options)
        end
        (select_options.join("\n") + "\n").html_safe
      end

      # Builds select tag from date type and html select options
      #  build_select(:month, "<option value="1">January</option>...")
      #  => "<select id="post_written_on_2i" name="post[written_on(2i)]">
      #        <option value="1">January</option>...
      #      </select>"
      def build_select(type, select_options_as_html)
        select_options = {
          :id => input_id_from_type(type),
          :name => input_id_from_type(type)
        }.merge(@html_options)
        select_options.merge!(:disabled => 'disabled') if @options[:disabled]

        select_html = "\n"
        select_html << content_tag(:option, '', :value => '') + "\n" if @options[:include_blank]
        select_html << prompt_option_tag(type, @options[:prompt]) + "\n" if @options[:prompt]
        select_html << select_options_as_html

        (content_tag(:select, select_html.html_safe, select_options) + "\n").html_safe
      end

      # Builds a prompt option tag with supplied options or from default options
      #  prompt_option_tag(:month, :prompt => 'Select month')
      #  => "<option value="">Select month</option>"
      def prompt_option_tag(type, options)
        prompt = case options
          when Hash
            default_options = {:year => false, :month => false, :day => false, :hour => false, :minute => false, :second => false}
            default_options.merge!(options)[type.to_sym]
          when String
            options
          else
            I18n.translate(:"datetime.prompts.#{type}", :locale => @options[:locale])
        end

        prompt ? content_tag(:option, prompt, :value => '') : ''
      end

      def build_hidden_inputs
        hidden_html = []
        DATEFIELDS.each do |fld|
          hidden_html << build_hidden(fld.to_sym, send(fld))
        end
        hidden_html.join("\n");
      end

      # Builds hidden input tag for date part and value
      #  build_hidden(:year, 2008)
      #  => "<input id="post_written_on_1i" name="post[written_on(1i)]" type="hidden" value="2008" />"
      def build_hidden(type, value)
        (tag(:input, {
          :type => "hidden",
          :id => input_id_from_type(type),
          :name => input_name_from_type(type),
          :value => value
        }.merge(@html_options.slice(:disabled))) + "\n").html_safe
      end

      def build_date_select
        input_html = []
        input_html << build_auxiliary(:date, 'text')
        input_html << build_auxiliary(:date_alt)
        input_html.join("\n")
      end

      def build_auxiliary(id, type = 'hidden', post = false)
        options = {
          :type => type,
          :id => input_id_from_type(id),
          :value => ''
        }
        # use id for name because the field is not a field of the time data response
        options[:name] = input_id_from_type(id) if post
        options.merge(@html_options.slice(:disabled))
        (tag(:input, options) + "\n").html_safe
      end 

      def build_script_support
        script = <<-SCRIPT
        $(function() {
          $.rails_date_time_select('#{input_id_from_type(nil)}') 
        });
        SCRIPT
        (javascript_tag script).html_safe
      end

      # Returns the name attribute for the input tag
      #  => post[written_on(1i)]
      def input_name_from_type(type)
        prefix = @options[:prefix] || DEFAULT_PREFIX
        prefix += "[#{@options[:index]}]" if @options.has_key?(:index)

        field_name = @options[:field_name] || type
        suffix = POSITION[type]
        #puts "input_name_from_type has type #{type} that is a #{type.class}, suffix #{suffix}"
        if suffix
          field_name += "(#{suffix}i)"
        elsif type
          field_name += "_#{type}"
        end

        @options[:discard_type] ? prefix : "#{prefix}[#{field_name}]"
      end

      # Returns the id attribute for the input tag
      #  => "post_written_on_1i"
      def input_id_from_type(type)
        input_name_from_type(type).gsub(/([\[\(])|(\]\[)/, '_').gsub(/[\]\)]/, '')
      end

      # Given an ordering of datetime components, create the selection HTML
      # and join them with their appropriate separators.
      def build_selects_from_types(order)
        select = ''
        order.reverse.each do |type|
          separator = separator(type) unless type == order.first # don't add on last field
          select.insert(0, separator.to_s + send("select_#{type}").to_s)
        end
        select.html_safe
      end

      def build_time_zone_offset
        span_options = {
          :id => input_id_from_type(:offset_display),
          :class => 'timeOffset' 
        }.merge(@html_options)
        (tag(:span, span_options) + "\n").html_safe
      end 

      # Returns the separator for a given datetime component
      def separator(type)
        case type
          when :date
            @options[:date_separator]
          when :hour
            @options[:datetime_separator]
          when :minute
            @options[:time_separator]
          when :second
            @options[:time_separator]
        end
      end
  end
end


# Extension for InstanceTag
# ActionView::Helpers::InstanceTag.send :include, JQDateTimeInstanceTag
module JQDateTimeInstanceTag
  def to_jq_datetime_select_tag(options = {}, html_options = {})
    jq_datetime_selector(options, html_options).select_datetime.html_safe
  end

  private
    def jq_datetime_selector(options, html_options)
      datetime = value(object) || jq_default_datetime(options)

      options = options.dup
      options[:field_name] = @method_name
      options[:include_position] = true
      options[:prefix] ||= @object_name
      options[:index] = @auto_index if @auto_index && !options.has_key?(:index)

      ::JQDateTimeHelper::JQDateTimeSelector.new(datetime, options, html_options)
    end

    def jq_default_datetime(options)
      return if options[:include_blank] || options[:prompt]

      case options[:default]
        when nil
          Time.current
        when Date, Time
          options[:default]
        else
          default = options[:default].dup

          # Rename :minute and :second to :min and :sec
          default[:min] ||= default[:minute]
          default[:sec] ||= default[:second]

          time = Time.current

          [:year, :month, :day, :hour, :min, :sec].each do |key|
            default[key] ||= time.send(key)
          end

          Time.utc_time(
            default[:year], default[:month], default[:day],
            default[:hour], default[:min], default[:sec]
          )
      end
    end
end

# extension for FormBuilder
# ActionView::Helpers::FormBuilder.send :include, JQDateTimeBuilder
module JQDateTimeBuilder
    def jq_datetime_select(method, options = {}, html_options = {})
      @template.jq_datetime_select(@object_name, method, objectify_options(options), html_options)
    end
end

