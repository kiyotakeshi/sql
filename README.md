```shell
docker-compose up -d

docker-compose exec postgres bash

psql -U postgres wakarimi
```


```shell
docker-compose exec postgres bash -c 'psql -U postgres wakarimi -c "\i /tmp/test.sql"'
```
