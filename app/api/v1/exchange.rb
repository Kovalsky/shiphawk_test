module V1
  class Exchange < Grape::API

    version 'v1', using: :path
    format :json
    prefix :api

    rescue_from ExchangeService::InvalidExchange do |e|
      error!(e, 422)
    end

    resource :atms do
      desc "List of atms"
      get do
        Atm.all
      end

      route_param :id do

        desc "Load money to atm's dispenser"
        params do
          requires :dispenser, type: Hash do
            %w(50 25 10 5 2 1).each do |bill|
              optional bill, type: Integer, values: ->(v){ v > 0}, desc: "amount of #{bill} bills"
            end
          end
        end
        post do
          atm = Atm.find_by(id: params[:id])
          atm.update(dispenser: params[:dispenser])
          atm
        end

        desc "Exchange some amount of money"
        params do
          requires :amount, type: Integer, desc: "amount of money to exchange"
        end
        post :exchange do
          atm = Atm.find_by(id: params[:id])
          exchange_result = ExchangeService.new(atm, params[:amount]).call
          exchange_result
        end
      end
    end

  end
end
