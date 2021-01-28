if Rails.env === 'production' 
    Rails.application.config.session_store :cookie_store, key: "_backend", domain: "http://teachers-pet-online-backend.herokuapp.com/"
    # Rails.application.config.session_store :cookie_store, key: '_backend'
else
    Rails.application.config.session_store :cookie_store, key: '_backend' 
end