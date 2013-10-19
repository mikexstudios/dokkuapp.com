dokkuapp.com
============

Automatic subdomains for dokku deployed apps: `http://appname.dokkuapp.com` similar to 
Heroku's app subdomain system except that we use DNS to map the subdomain to a server IP
address instead of proxying the request through a load balancer. To use in your dokku 
installation, install the [dokku-dokkuapp][1] plugin.

How do I use this?
------------------

To use in your dokku installation, install the [dokku-dokkuapp][1] plugin.

#### Here's how to use the API:

* To **request a subdomain** (i.e., `http://myapp.dokkuapp.com`), send a `POST` request to
  `http://www.dokkuapp.com/api/v1/apps` with parameter `name` set to the subdomain that
  you are requesting. The expected JSON response confirms the name to IP address
  mapping:
    ```sh
    $ curl -X POST -d'name=myapp' http://www.dokkuapp.com/api/v1/apps
    {"name":"myapp","address":"[your ip address]"}
    ```

  By default, the API will set the IP address of the subdomain mapping to the client's
  IP address. To **manually set the address**, pass the `address` parameter:
    ```sh
    $ curl -X POST -d'name=myapp&address=1.1.1.1' http://www.dokkuapp.com/api/v1/apps
    {"name":"myapp","address":"1.1.1.1"}
    ```

* To **view an association**, send a `GET` request to 
  `http://www.dokkuapp.com/api/v1/apps/[myapp]` where `[myapp]` is the subdomain:
    ```sh
    $ curl http://www.dokkuapp.com/api/v1/apps/myapp
    {"name":"myapp","address":"1.1.1.1"}
    ```

* To **delete an association**, send a `DELETE` request to 
  `http://www.dokkuapp.com/api/v1/apps/[myapp]` where `[myapp]` is the subdomain:
    ```sh
    $ curl -X DELETE http://www.dokkuapp.com/api/v1/apps/myapp
    {"status":"success","message":"App association has been deleted!"}
    ```

[1]: https://github.com/mikexstudios/dokku-dokkuapp

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
2. Set configuration variables for dokkuapp.com as [environment variables on heroku][2]. 
   See `.env.sample` file for what variables need to be set. Ignore the `PORT` and `RACK_ENV` 
   variables since they are for local use).

   ```bash    
   heroku config:set SECRET_TOKEN=[your secret token generated with rake secret]
   heroku config:set AWS_ACCESS_KEY=[your aws access key]
   etc.
   ```
   
3. Migrate the database: `heroku run rake db:migrate`.
4. *(Optional)* Sign up for a [New Relic][3] account, create a new application to monitor, and
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
   servers. Then, follow [Heroku's guide on configuring Route 53][4].


[2]: https://devcenter.heroku.com/articles/config-vars
[3]: https://newrelic.com/
[4]: https://devcenter.heroku.com/articles/route-53#naked-root-domain

Using the admin interface
-------------------------

The admin interface is based off of [rails_admin][5] and uses [cancan][6] to restrict access 
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

[7]: https://github.com/sferik/rails_admin
[8]: https://github.com/ryanb/cancan
