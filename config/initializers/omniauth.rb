Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'eFHtNGPejVCAmnG74tzA', 'oPa0KnT9N7kKWPLQUbkBL9GhAjpV6cA6Ygu9P7i4K0'
  provider :facebook, '128988040504632', '327eecbe5ce5ee8f91e50ffd3f067f78'
end

