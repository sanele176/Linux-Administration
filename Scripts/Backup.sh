#!/bin/bash

zip /scripts/backup.zip /var/www/html/news
scp /scripts/backup.zip user@destination:/backup
