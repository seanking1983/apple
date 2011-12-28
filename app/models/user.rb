class User < ActiveRecord::Base
  
  attr_accessor   :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,      :presence     => true,
                        :length       => { :maximum => 50 }                    
  validates :email,     :presence     => true,
                        :format       => email_regex,
                        :uniqueness   => { :case_sensitive => false }
  validates :password,  :presence     => true,
                        :confirmation => true,
                        :length       => { :within => 6..40 }                        
  

  before_save :encrypt_password



  private
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
  
    def encrypt(string)
      Digest::SHA2.hexdigest("#{salt}--#{string}")
    end
    
    def make_salt
      Digest::SHA2.hexdigest("#{Time.now.utc}--#{password}")
    end
    
      
end
# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#

