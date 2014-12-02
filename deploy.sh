#!/bin/sh

APPNAME="smmobe"
BRANCH="master"

if [ $1 ]; then
	ENV=$1
	
	if [ $ENV != 'stage' ] && [ $ENV != 'prod' ]; then
		echo "Specified arguments are invalid. Accepted arguments: stage, prod."
		exit 1
	fi

	if [ $ENV == 'stage' ]; then
		APPNAME="smmobe-staging"
		BRANCH="develop:master"
	fi

	if [ $2 ]; then
		BRANCH=$2
	fi

	echo "============================= Deployment $1 Started ============================="
	
	echo "--- Run linting to check for errors ---"
	rubocop --fail-fast --fail-level 'E'

	# TODO: run tests

	if [ $? == 1 ]; then
		echo " Exiting as found compiation errors. "
		exit 1
	fi

	echo "--- Deploying to Heroku ---"
	git push -v staging $BRANCH

	if [ $? == 1 ]; then
		echo " Exiting as deployment failed. "
		exit 1
	fi

	echo "-- Running DB migration ---"
	heroku run rake db:migrate --app $APPNAME

	if [ $? == 1 ]; then
		echo " Exiting as db migration failed. "
		exit 1
	fi

	echo "============================= Deployment $1 Finished ============================="
else
   echo " No arguments specified. Accepted arguments: stage, prod. "
fi


