export AWS_PROFILE=epam

aws kms list-keys
# Create the CMK
aws kms create-key --description "KMS workshop - envelope encryption CMK"
aws kms create-alias --target-key-id 2b989d1d-963d-4f05-9531-9ac4a33e3f02 --alias-name alias/workshop-kms-cmk
aws kms generate-data-key --key-id alias/workshop-kms-cmk --key-spec AES_256

export DATA_KEY_CIPHERTEXT="AQIDAHgXa6k4P48VD5fRAnKvv2drHEhWFCHnCjfmve8kEWv04wGMSGsC7TS11zAr5foWlzAOAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMM1qPRlo0ANkWePZDAgEQgDvfEFkWX6JmTjA/oHoFEOC1SvAdIzcfPH0o7AUfRvmqbJVfvwwA4yY2RTprVqFUtTKEzSCf95TVyyJbug=="

export DATA_KEY_PLAINTEXT=`aws kms decrypt --ciphertext-blob fileb://./data_key_ciphertext --query Plaintext --output text`
echo "$DATA_KEY_PLAINTEXT" | base64 --decode > ./data-key-plaintext
echo "Hello! I would like to be encrypted, thanks."  | openssl enc -e -aes256 -k file://./data-key-plaintext > ./ciphertext
cat ./ciphertext | openssl enc -d -aes256 -k file://./data-key-plaintext

#cleanup
aws kms delete-alias --alias-name alias/workshop-kms-cmk
aws kms schedule-key-deletion --key 2b989d1d-963d-4f05-9531-9ac4a33e3f02 --pending-window-in-days 1
