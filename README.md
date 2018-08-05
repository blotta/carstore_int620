# Car Store

## INT620

Clone repo
```
$ cd /export/srv/www/vhosts/main
$ git clone https://github.com/blotta/carstore_int620.git store_int620
```

Install Apache config and restart service
```
$ cp store_int620/default-server.conf /etc/apache2/
$ sudo systemctl restart apache2
```

Place Google Maps Places API key on project root
```
$ echo '<key>' > gmaps-key.txt
```
