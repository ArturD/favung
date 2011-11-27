# About Favung #

# Requirements #

 * Ruby 1.9.2
 * MongoDB ~> 2.0.1
 * RabbitMQ

## Install RabbitMQ ##

Please refer to the [RabbitMQ installation guide](http://www.rabbitmq.com/install.html).

## Install MongoDB ##

Please refer to the [MongoDB QuickStart](http://www.mongodb.org/display/DOCS/Quickstart).

## Getting Started ##

1. Ensure RabbitMQ and MongoDB are running.

2. Seed your application

``` bash
cd $REPO_ROOT/webfront
rake db:seed
```

3. Start agent in new console

``` bash
cd $REPO_ROOT/agent
ruby agent.rb
```

4. Start web front

``` bash
cd $REPO\_ROOT/webfront
rails s
```

5. Open localhost:3000 in browser



