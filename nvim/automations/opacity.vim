" execute.vim
"
e ~/.config/alacritty/alacritty.yml

if search('opacity: 0.7', 'nw')
    %s/opacity: 0.7/opacity: 1/g
elseif search('opacity: 1', 'nw')
    %s/opacity: 1/opacity: 0.7/g
endif
wq

