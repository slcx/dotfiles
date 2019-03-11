function spectrogram
  set -l options 'showspectrumpic=s=1024x512:stop=22000'
  set -l path '/tmp/spectrogram.png'
  echo 'generating spectogram...'
  ffmpeg -v info -y -i $argv[1] -filter_complex "$options" "$path"
  and open "$path"
end
