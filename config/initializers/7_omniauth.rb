if Gitlab::LDAP::Config.enabled?
  module OmniAuth::Strategies
    server = Gitlab.config.ldap.servers.values.first
    klass = server['provider_class']
    const_set(klass, Class.new(LDAP)) unless klass == 'LDAP'
  end

  OmniauthCallbacksController.class_eval do
    server = Gitlab.config.ldap.servers.values.first
    alias_method server['provider_name'], :ldap
  end
end

OmniAuth.config.allowed_request_methods = [:post]
OmniAuth.config.before_request_phase do |env|
  OmniAuth::RequestForgeryProtection.new(env).call
end
