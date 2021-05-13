function spek
  set -l id (random)
  set -l path '/tmp/spectrogram-'(random)'.png'

  echo "creating spek @ $path"

  sox $argv[1] -n spectrogram -o "$path"
  and open "$path"
end
