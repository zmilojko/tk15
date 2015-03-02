class User
  include Mongoid::Document
  # include Mongoid::Paperclip
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  
  # Additional fields
  field :name,      type: String
  field :club,      type: String
  field :dogs,      type: String
  field :appnum,    type: String
  field :receipt_file,    type: String
  #has_mongoid_attached_file :receipt
  #do_not_validate_attachment_file_type :receipt
  
  field :admin,      type: Boolean, default: false
  
  def competitions
    self[:races].join(", ")
  end
  def competitions=(x)
    self[:races] = x.split /[, ]+/
    Competition.collection.find(_id: self._id).update("$set" => { races: self[:races]})
  end
end
