class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token
	before_save :downcase_email
	before_create :create_activation_digest
	has_many :microposts, dependent: :destroy

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX },uniqueness: true
	validates :password, presence: true, length: { minimum: 5 }, allow_nil: true

	has_secure_password
	
	# Returns the hash digest of the given string.
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
		BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	def self.new_token
		SecureRandom.urlsafe_base64
	end

	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	def feed
		Micropost.where("user_id = ?", id)
	end

	#is same as
	# def feed
	#   microposts
	# end
	

	
	private
	def downcase_email 
		self.email = email.downcase
	end

	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end

	# returns true if the given token matches the digest
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def activate 
		# update_attribute(:activated, true)
		# update_attribute(:activated_at, Time.zone.now)
		update_columns(activated: true, activated_at: Time.zone.now)
	end

end
	
