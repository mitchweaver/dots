# spotify flatpak

note only for amd64 no arm linux client yet


## logging in initially

because theres no firefox in the flatpak environment you wont be able to log in

force setting of credentials on first launch with this:

flatpak run com.spotify.Client --username=deviceusername --password=regularspotifypassword --show-console

## more annoying

if logged out, wont let you log back in unless you have no browsers open

close all instances of firefox, kill spotify, reopen spotify, click login
then it will open

also you need this installed: xdg-desktop-portal-gtk


STOP THIS BROWSER LOG IN NONSENSE SPOTIFY WHY CANT WE JUST TYPE INFO INTO THE APP WTF
