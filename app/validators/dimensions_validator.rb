class DimensionsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    attachment = record.send(attribute)
    if (!attachment.queued_for_write.empty?)
      dimensions = Paperclip::Geometry.from_file(attachment.queued_for_write[:original].path)
      width = options[:width]
      height = options[:height]
      record.errors[attribute] << "width must be greater than #{width}px" unless dimensions.width >= width
      record.errors[attribute] << "height must be greater than #{height}px" unless dimensions.height >= height
    end
  end
end