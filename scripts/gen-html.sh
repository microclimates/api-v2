node node_modules/aglio/bin/aglio.js --theme-full-width --theme-variables styles.less -i apiary.apib -o temp.html
sed 's/Resource Group/Resources/g' < temp.html > climate-control-api.html
rm -f temp.html
