Welcome to Foinz
=================

To start the the dev environment run 

`mongod`


then ```shotgun app.rb``` make sure you `bundle install`

If you want to sign in with fb, you need to add the following line in /etc/hosts
(make sure you are sudo)

```127.0.0.1 local.foinz.com```


To run the console run ```racksh```

To debug something add ```byebug``` and wait for the server to be intercepted. 

#### How to get started with writing tests? 

Rspec 3 is great, it consists of three main componenets (core, expecations, and mocks). Find the links here

[core](http://www.rubydoc.info/gems/rspec-core/frames)

[expecataions](http://www.rubydoc.info/gems/rspec-expectations/frames)

[mocks](http://www.rubydoc.info/gems/rspec-mocks/frames)
