class User < ActiveRecord::Base
  attr_accessible :anonymity_count, :department, :email, :fb_link, :first_name, :last_name, :session_token

  def create_user(params)
    user = User.new(params)
    user.session_token  = user.get_session_token()
    user.save
  end

  def get_profile()
    {
      'first_name'      => self.first_name,
      'last_name'       => self.last_name,
      'anonymity_count' => self.anonymity_count,
      'email'           => self.email,
      'fb_link'         => self.fb_link,
      'department'      => DepartmentList.get_index(self.department)
    }
  end

  def update_profile(params)
    self.update_attributes(:department => DepartmentList.get_index(params[:department]))
  end

  def get_session_token
    if self.session_token.blank?
     self.session_token = self.id.to_s + SecureRandom.base64(64).gsub(/[$=+\/]/,65.+(rand(25)).chr)
     self.save
    end
    return self.session_token
  end
end
