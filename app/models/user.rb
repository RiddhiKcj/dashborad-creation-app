class User < ApplicationRecord
    has_secure_password
    has many :active_apis, depenedent: :destroy
end
