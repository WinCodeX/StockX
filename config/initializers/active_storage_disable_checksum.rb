# config/initializers/active_storage_disable_checksum.rb

Rails.application.config.after_initialize do
  ActiveSupport.on_load(:active_storage_service) do
    require "active_storage/service/s3_service"

    ActiveStorage::Service::S3Service.class_eval do
      def upload(key, io, checksum: nil, **options)
        instrument :upload, key: key, checksum: checksum do
          object = object_for(key)
          options = options.merge(body: io)
          object.put(options)
        end
      end
    end
  end
end