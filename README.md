```
rake db:create RAILS_ENV=production DB_USER=root DB_PASS=pass
rake db:migrate RAILS_ENV=production DB_USER=root DB_PASS=pass
```

```
rake assets:clean RAILS_ENV=production
rake assets:precompile RAILS_ENV=production

```
RAILS_SERVE_STATIC_FILES=true SECRET_KEY_BASE=$(rake secret) rails s -p 3000 -b 0.0.0.0 -e production -d
```
