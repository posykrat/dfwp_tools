#!/usr/bin/env bash
#
#
#
# Script d'export de BDD
# Accès SSH nécesaire
#
#
#

# Config vhost
vhost_local='http://localhost/exemple'
vhost_dist='http://preprod.exemple.com'

# Config path
projet_folder='h:/www/labinocle'
tmp_dist_folder='/home/username/tmp'
project_dist_folder='/home/username/public_html/preprod/exemple'

# Config file name
d=$(date +%Y-%m-%d_%Hh-%Mm-%Ss)
export_file_name='export-'$d'.sql'

# Config SSH
ssh_info='user@server'

cd $projet_folder

echo "Export de la bdd locale"
wp search-replace $vhost_local $vhost_dist --export=$export_file_name
echo "--------------------------------------"

echo "Copie de du fichier sql"
scp $export_file_name $ssh_info:$tmp_dist_folder
echo "--------------------------------------"

echo "Suppression du fichier d'export en local"
rm $export_file_name
echo "--------------------------------------"

echo "Connexion SSH, import des données et suppresion du fichier sql"
ssh $ssh_info "cd $project_dist_folder && php ~/bin/wp db import $tmp_dist_folder/$export_file_name && rm $tmp_dist_folder/$export_file_name"
echo "--------------------------------------"

exit