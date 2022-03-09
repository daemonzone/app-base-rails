#!/bin/sh

TODAY=$(date '+%Y%m%d')

cd /Users/davide/WorkingOn/AVQ/HerokuBackups

# heroku pg:backups:schedule DATABASE_URL --at '11:00 Europe/Rome'
# heroku pg:backups:capture --app avq-portaleservizi

/usr/local/heroku/bin/heroku pg:backups:download --app avq-portaleservizi

mv latest.dump ${TODAY}_avq-portaleservizi.dump
