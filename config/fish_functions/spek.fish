function spek
  set -l id (random)
  set -l options 'showspectrumpic=s=1024x512:stop=22000'
  set -l path '/tmp/spectrogram-'(random)'.png'

  echo 'generating spectogram...'
  ffmpeg -v warning -y -i $argv[1] -filter_complex "$options" "$path"
  and open "$path"
end
