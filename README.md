RSSPaper
========

rss -- instapaper --> rss with content

Run
---

    $ rackup config.ru

and open [http://localhost:9292/](http://localhost:9292/).

Setting up for heroku
---------------------

    $ heroku create YOUR_APP
    $ heroku addons:add memcache:5mb
    $ git push git@heroku.com:YOUR_APP.git
