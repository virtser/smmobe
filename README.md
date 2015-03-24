# Description

Smmobe is a web platform that enables SMBs representatives to instantly and cost effectively create an automatic dialog with their customers using text (SMS) messages. 

It is an online platform for self-creation of 2-way SMS dialogs and their distribution to multiple recipients.

Examples of use cases are: 

* Promotions
* Surveys
* Scheduling 
* Clarifications.


# General info

Technology being used:

- Ruby on Rails as server side, APIs and ORM.
- PostgreSQL as database.
- Twitter bootstrap for client components.
- Nexmo as SMS gateway provider.
- Heroku as cloud application platform.
- New Relic for monitoring.

# Installation

1. Make sure Ruby '2.1.2', Rails '4.1.4' and PostgreSQL are installed on your machine.

2. Run ``` bundle install ``` in root directory to install all project dependencies.

3. Executre ``` rake db:migrate ``` and ``` rake db:seed ``` to run database migrations and seed initial data.

4. Run the server ```rails s```.

5. Deploy changes to heroku by using the *[deploy.sh](https://github.com/virtser/smmobe/blob/master/deploy.sh)* script. It has staging and development environments support as well as other branch names but 'master'. It will run linting check before deployment and db migrations after deployment to prevent any production errors. Of course all tests should be executed in this stage as well [TBD].

