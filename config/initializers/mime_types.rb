# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

#.webapp is the Mozilla Firefox manifest format
#https://developer.mozilla.org/en-US/Apps/Developing/Manifest
Rack::Mime::MIME_TYPES['.webapp'] = 'application/x-web-app-manifest+json'