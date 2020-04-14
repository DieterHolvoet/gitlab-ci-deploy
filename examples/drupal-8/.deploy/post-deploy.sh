./vendor/bin/drush cache-rebuild
./vendor/bin/drush updatedb --no-post-updates
./vendor/bin/drush config-import
./vendor/bin/drush updatedb
./vendor/bin/drush cache-rebuild
