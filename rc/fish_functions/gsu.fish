function gsu -d "Sets up a Git repository"
  if [ (count $argv) -eq 0 ]
    echo "usage: gsu <remote>"
    return
  end

  git remote add origin argv[1]
  git push -u origin master
end
