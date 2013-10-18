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
4. *(Optional)* Sign up for a [New Relic][2] account, create a new application to monitor, and
   then note your license key. Then set the license key as a environment variable in Heroku: 
   `heroku config:set NEW_RELIC_LICENSE_KEY=[license key here]`. Restart your dyno to see your
   app appear in New Relic.
5. *(Optional)* Set up availability monitoring in New Relic under Settings -> Availability 
   Monitoring for your app. Set a url to ping every 5 minutes (e.g. 
   `https://myapp.herokuapp.com/api/v1/apps/[randomstring]`). Make an entry for `[randomstring]`
   by curling your app: `curl -X POST -d'name=[randomstring]' https://myapp.herokuapp.com/api/v1/apps/`.
   Now New Relic will send you an alert if your app goes down!
6. *(Optional)* Set up a custom domain that points to the heroku app. First, make sure that
   the domain is registered and that the nameservers are pointed at Amazon's Route 53 DNS 
   servers. Then, follow [Heroku's guide on configuring Route 53][3].


[1]: https://devcenter.heroku.com/articles/config-vars
[2]: https://newrelic.com/
[3]: https://devcenter.heroku.com/articles/route-53#naked-root-domain

Using the admin interface
-------------------------

The admin interface is based off of [rails_admin][4] and uses [cancan][5] to restrict access 
to users with the `.admin` flag set to `true`. To use:

1. Visit `https://yourapp.herokuapp.com/admin/` and sign up.
2. Open a Heroku console: `heroku run rails console`.
3. Select your user and set the `.admin` flag to `true`:

   ```ruby
   irb(main):001:0> u = User.find(1)
   irb(main):002:0> u.admin = true
   irb(main):003:0> u.save
   irb(main):004:0> exit
   ```

4. Now you should be able to log into the admin section.

[4]: https://github.com/sferik/rails_admin
[5]: https://github.com/ryanb/cancan
