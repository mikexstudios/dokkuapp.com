#Configuration for route53

Rails.application.config.route53_zone = ENV.fetch('ROUTE53_ZONE', 'dokkuapp.com')
Rails.application.config.route53_zoneid = ENV['ROUTE53_ZONEID']
Rails.application.config.route53_ttl = 60 #seconds
