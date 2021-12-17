mkdir -p bin
mkdir -p nodejs
if [ $1 = "both" ]
then
  cp package.json nodejs/package.json 
  ( cd nodejs ; npm install --silent > /dev/null )
  zip -r bin/lambda_layer.zip ./nodejs > /dev/null
fi
zip -r ../bin/code.zip . -i "**" > /dev/null
echo -n "{\"lambda_code\":\"bin/code.zip\", \"layer_code\":\"bin/lambda_layer.zip\"}"
