#!/bin/sh

STAGE_BRANCH="develop:master"
PROD_BRANCH="master"

if [ $1 ]; then
	ENV=$1
	
	if [ $ENV != 'stage' ] && [ $ENV != 'prod' ]; then
		echo "Specified arguments are invalid. Accepted arguments: stage, prod."
		exit 1
	fi

	if [ $2 ]; then
		STAGE_BRANCH=$2
		PROD_BRANCH=$2
	fi

	echo "============================= Deployment $1 Started ============================="
	
	echo "Run linting to check for errors"
	rubocop --fail-fast --fail-level 'E'

	# TODO: run tests

	if [ $? == 1 ]; then
		echo " Exiting as found compiation errors. "
	else
		if [ $ENV == 'stage' ]; then
			echo "Deploying to Heroku"
			git push staging $STAGE_BRANCH

			echo "Running DB migration"
			heroku run rake db:migrate --app smmobe-staging
		else
			echo "Deploying to Heroku"
			git push heroku $PROD_BRANCH
			
			echo "Running DB migration"
			heroku run rake db:migrate --app smmobe
		fi
	fi

	echo "============================= Deployment $1 Finished ============================="
else
   echo " No arguments specified. Accepted arguments: stage, prod. "
fi


