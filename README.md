dokkuapp.com
============

Automatic subdomains for dokku deployed apps: `http://appname.dokkuapp.com` similar to 
Heroku's app subdomain system except that we use DNS to map the subdomain to a server IP
address instead of proxying the request through a load balancer.

How does it work?
-----------------

This is a basic Rails 4 app that uses the grape gem to implement a basic API for creating app 
name to server IP address associations. We use Amazon Route 53's DNS system with a low TTL 
(set to one minute) to enable fast mapping of subdomains of the form 
(`http://appname.dokkuapp.com`) to your server. The low TTL forces DNS servers to requery for
the address of the subdomain. However, caching DNS server may override this TTL setting.

Deploying on Heroku
-------------------

1. Create your heroku app and push to it: `git push heroku master`.
2. Set configuration variables for dokkuapp.com as [environment variables on heroku][1]. 
   See `.env.sample` file for what variables need to be set. Ignore the `PORT` and `RACK_ENV` 
   variables since they are for local use).

   ```bash    
   heroku config:set SECRET_TOKEN=[your secret token generated with rake secret]
   heroku config:set AWS_ACCESS_KEY=[your aws access key]
   etc.
   ```
   
3. Migrate the database: `heroku run rake db:migrate`.
4. That's it!

[1]: https://devcenter.heroku.com/articles/config-vars
