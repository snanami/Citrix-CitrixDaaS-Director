#------------------------------------------------------------------------------------------
# 手順2-1.で取得した情報を変数に格納
#------------------------------------------------------------------------------------------
$customerId = "xxxxxxxxxxxx"
$clientId = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$clientSecret = "xxxxxxxxxxxxxxxxxxxxxxxx"


#------------------------------------------------------------------------------------------
# トークンを取得する関数GetBearerTokenを定義
#------------------------------------------------------------------------------------------
function GetBearerToken {

param (
[Parameter(Mandatory=$true)]
[string] $clientId,
[Parameter(Mandatory=$true)]
[string] $clientSecret
)

$body = @{
    grant_type = "client_credentials";
    client_id = $clientId;
    client_secret = $clientSecret
}

$trustUrl = "https://< EndpointBasedOnGeographicalRegion >/cctrustoauth2/root/tokens/clients"

$response = Invoke-RestMethod -Uri $trustUrl -Method POST -Body $body

$bearerToken = $response.access_token

return $bearerToken;
}



#------------------------------------------------------------------------------------------
# GetBearerTokenの実行
#------------------------------------------------------------------------------------------
$bearerToken = GetBearerToken $clientId $clientSecret
$token = "CwsAuth Bearer="+ $bearerToken



#------------------------------------------------------------------------------------------
# ログデータ(JSON)取得のためのAPIリクエスト
#------------------------------------------------------------------------------------------
$headers = @{
    authorization = $token;
    "Citrix-CustomerId" = $customerId;
}

$url = "https://< EndpointBasedOnGeographicalRegion >/monitorodata/< DataSets >"
$result = Invoke-WebRequest -Uri $url -Headers $headers 



#------------------------------------------------------------------------------------------
# ログデータの出力
#------------------------------------------------------------------------------------------
$filename = Get-Date -Format "yyyy-MMdd-HHmmss"
$result.content | Out-File "< FolderPath >\< FolderName >$filename.json"