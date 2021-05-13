function twdl
  set -l url (curl -X POST https://tvd.now.sh/resolve -H 'Content-Type: application/json' --data "{\"url\":\"$argv[1]\",\"quality\":\"high\"}")
  wget "$url" -O vid.mp4
end
