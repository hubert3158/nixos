
#
#-------------------- Local ----------------------


# Start a new tmux session with the first window named Misc
 tmux new-session -d -s local -n Misc 

# Create new windows in the session
# tmux new-window -t local:1 -n Nvim -c ~/.config/nvim 'nvim init.lua'
# tmux new-window -t local:2 -n Influx-MCA-Web -c ~/dev/web/influx-mca-web 'nvim pom.xml'

#-------------------- Local ----------------------

#-------------------- Development----------------------

# Start a new tmux session with the first window named Misc
 tmux new-session -d -s dev -n Development

# Create new windows in the session

#-------------------- Development ----------------------


#-------------------- Staging ----------------------


# tmux new-session -d -s stg -n Staging 'ssh stg.v2'
# tmux split-window -h -t stg:0
#
# # Send keys to the second pane to execute the desired commands
# tmux send-keys -t stg:0.1 'ssh stg.v2' C-m
# # tmux send-keys -t stg:0.1 'cd workspace/app/web/influx-mca-web/launch' C-m
# tmux send-keys -t stg:0.1 'tail -f nohup.out' C-m

#-------------------- Staging ----------------------


#-------------------- Production ----------------------

# tmux new-session -d -s prod -n Production 'ssh prod.v2'
# tmux split-window -h -t prod:0

# # Send keys to the second pane to execute the desired commands
# tmux send-keys -t prod:0.1 'ssh prod.v2' C-m
# tmux send-keys -t prod:0.1 'cd workspace/app/web/influx-mca-web/launch' C-m
# tmux send-keys -t prod:0.1 'tail -f nohup.out' C-m

#-------------------- Production ----------------------

# Attach to the tmux session
tmux attach -t local

