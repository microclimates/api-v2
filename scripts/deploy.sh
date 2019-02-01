echo "Uploading to the CDN..."
file=climate-control-api.html

aws s3 cp --acl public-read ${file} s3://go.microclimates.com/${file}
aws cloudfront create-invalidation --distribution-id EBHD0387P75QF --paths /${file}
