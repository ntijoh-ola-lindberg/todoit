# Todo webbapp i Ruby med Sinatra och SQLite för Webbserverprogrammering 1

## Installera
```
brew install ruby ruby-install chruby
ruby-install 3.3

gem install bundler
bundle install
``` 

## Köra
``` 
rake run
``` 

## Databas

Fyll databasen med test-data
``` 
rake seed
``` 

 Använd [DB Browser for SQLite](https://sqlitebrowser.org) för att läsa och ändra manuellt i databasen.