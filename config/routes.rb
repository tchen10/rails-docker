Rails.application.routes.draw do
  mount V1::UsersApi => '/v1'
end
