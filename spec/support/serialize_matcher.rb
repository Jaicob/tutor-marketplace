# RSpec matcher to spec serialized ActiveRecord attributes.
#
# Usage:
#
#     describe Post do
#       it { should serialize(:data) }                 # serialize :data
#       it { should serialize(:registers).as(Array) }  # serialize :registers, Array
#       it { should serialize(:options).as(Hash) }     # serialize :options, Hash
#     end

RSpec::Matchers.define :serialize do |attribute|
  chain(:as) { |type| @as = type }

  match do |model|
    @model = model.is_a?(Class) ? model : model.class

    @model.serialized_attributes.keys.should include(attribute.to_s)

    @model.serialized_attributes[attribute.to_s].should == @as if @as
  end

  description do
    "serialize :#{attribute}" << (@as ? " as a #{@as}" : "")
  end

  failure_message_for_should do |text|
    "expected #{@model} to serialize :#{attribute}" << (@as ? " as a #{@as}" : "")
  end

  failure_message_for_should_not do |text|
    "expected #{@model} not to serialize :#{attribute}" << (@as ? " as a #{@as}" : "")
  end
end