module TestHelper

  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

  def purchase_params
    params.require(:purchase).permit(:destination_name, :destination_postal_code, :destination_address, :credit_number)
  end

    class Rack::Test::CookieJar
      def signed
        self
      end

      def permanent
        self
      end

    end

    def remember(user)
      user.remember
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end

  #お気に入り判定
  def favproduct?(product)
    self.favproducts.include?(product)
  end

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end


  # 与えられたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  # def log_out
  #   forget(current_user)
  #   session.delete(:user_id)
  #   @current_user = nil
  # end

  def item_params
    params.require(:item).permit(:quantity, :product_id, :cart_id, :size_id)
  end



  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end


end
