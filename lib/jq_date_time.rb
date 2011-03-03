# JqDateTime
require(File.expand_path(File.join(File.dirname(__FILE__), 'jq_date_time', 'jq_date_time.rb')))
ActionView::Base.send :include, JQDateTimeHelper
ActionView::Helpers::FormBuilder.send :include, JQDateTimeBuilder
ActionView::Helpers::InstanceTag.send :include, JQDateTimeInstanceTag
