class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation

  ROLES = %w[user admin]

  field :role, default: 'user'

  has_many :submissions

  def admin?
    role == "admin"
  end

  def score
    self.submissions.find_all {|s| s.status == :accept}.
      map {|s| s.task.id}.
      uniq.
      size
  end

  def status_of(taskid)
    self.submissions.find_all {|s| s.task.id == taskid}.
      count {|s| s.status == :accept} != 0 ? :accepted : :not_accepted # FIXME not_accepted :)
  end
end
