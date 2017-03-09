localhost="localhost"
port=9200
echo
echo "Setting up data for tutorial. Please make sure docker-compose up "
echo "has been run."
echo
echo "Hostname: ${localhost}"
echo "Port:     ${port}"
echo
read -r -p "Continue? [y/N] " response
if [[ "$response" =~ ^([nN][oO]|[nN])+$ ]]
then
  exit
fi
echo "Defining mapping for Shakespeare data set"
echo
curl -XPUT http://${localhost}:${port}/shakespeare -d '
{
 "mappings" : {
  "_default_" : {
   "properties" : {
    "speaker" : {"type": "string", "index" : "not_analyzed" },
    "play_name" : {"type": "string", "index" : "not_analyzed" },
    "line_id" : { "type" : "integer" },
    "speech_number" : { "type" : "integer" }
   }
  }
 }
}
'
echo "Defining mappings for logstash data set"
echo
curl -XPUT http://${localhost}:${port}/logstash-2016.05.18 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
'
curl -XPUT http://${localhost}:${port}/logstash-2016.05.19 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
'
curl -XPUT http://${localhost}:${port}/logstash-2016.05.20 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
'
echo "Loading bank data set"
echo
curl -XPOST ${localhost}:${port}'/bank/account/_bulk?pretty' --data-binary @data/accounts.json
echo "Loading Shakespeare data set"
echo
curl -XPOST ${localhost}:${port}'/shakespeare/_bulk?pretty' --data-binary @data/shakespeare.json
echo "Loading logstash data set"
echo
curl -XPOST ${localhost}:${port}'/_bulk?pretty' --data-binary @data/logs.jsonl
echo "Verifying indices"
echo
curl ${localhost}:${port}'/_cat/indices?v'

