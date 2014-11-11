## Installation

Les instructions d'installation sont pour une machine basée sur Debian.

### ElasticSearch

* Installer ElasticSearch à l'aide du [paquet debian][debian-es]
* Démarrer le service `sudo service elasticsearch start`

### Postgresql

* Installer les paquets `postgresql` et `postgresql-contrib`
* Créer un utilisateur `ehstore` dédié à l'application
* Créer la base de développement
* Donner les privilèges à `ehstore` sur la base
* Activer l'extension hstore sur la base

[debian-es]: http://www.elasticsearch.org/overview/elkdownloads/


### Start elasticsearch

    sudo service elasticsearch start

Now you can access it on [localhost:9200](http://localhost:9200)
This is where you can find [Sense](http://localhost:9200/_plugin/marvel/sense/index.html).

### Populate database

In terminal:

    rake db:seed

###Create index in Sense

One way to create index is from Rails console:

    Product.__elasticsearch__.create_index! force: true 

However, if we need additional settings, like in this case we do, this should be done in Sense:

    PUT /products


###Populate products index

Then in terminal, run:

    bundle exec rake environment elasticsearch:import:model CLASS=Product

### Example in Sense

    GET products/_search
    {
      "size": 0,
      "query": {
        "prefix": {
          "properties.color": "p"
        }
      },
      "facets": {
        "color": {
          "terms": {
            "field": "properties.color"
          }
        }
      }
    }