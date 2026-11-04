$ErrorActionPreference = 'Stop'
$connectionString = 'DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;'
@('product-images', 'site-media', 'site-banners') | ForEach-Object {
  az storage container create --name $_ --public-access off --connection-string $connectionString | Out-Null
}
if ($LASTEXITCODE -ne 0) { throw 'Azurite container initialization failed.' }
Write-Host 'Azurite private containers product-images, site-media, and site-banners are ready.'
