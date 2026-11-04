#!/usr/bin/env bash
set -euo pipefail
connection_string='DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;'
for container in product-images site-media site-banners; do
  az storage container create --name "$container" --public-access off --connection-string "$connection_string" >/dev/null
done
echo 'Azurite private containers product-images, site-media, and site-banners are ready.'
