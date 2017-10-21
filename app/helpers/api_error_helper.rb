module ApiErrorHelper
  def error_for(code, error_object, type = nil)
    error!({ errors: error_message_for(type, error_object) }, code)
  end

  def error_message_for(type, error_object)
    case type
      when :record_invalid
        invalid_record_error_message error_object
      when :grape_validation_error
        error_object.full_messages
      else
        error_object
    end
  end

  def invalid_record_error_message(error_object)
    if error_object.record.present?
      error_object.record.errors.full_messages
    else
      'Record invalid'
    end
  end
end