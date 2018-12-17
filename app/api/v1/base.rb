module V1
  class Base < Grape::API

    formatter :json, Grape::Formatter::ActiveModelSerializers
    mount V1::Exchange
    add_swagger_documentation mount_path: '/api/v1/swagger_doc'
  end
end
