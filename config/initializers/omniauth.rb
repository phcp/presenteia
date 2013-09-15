Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '155341731319250', 'f0829a081122799e8fd766d7caed19d0', :scope => "email, read_friendlists"
end