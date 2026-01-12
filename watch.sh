while inotifywait -r --exclude "./_out/|./.lake/" -e close_write .; do
    lake exe blog;
    curl -X POST localhost:8000/api-reloadserver/trigger-reload;
done &
(cd _site/ && uvx reloadserver -w)
