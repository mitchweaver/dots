from ranger.api.commands import *
import os

class trash(Command):
    def execute(self):
        path=str(self.fm.thisdir.get_selection()[0])
        trash="~/.local/share/Trash/files"
        os.system("[ ! -d " + trash + " ] && mkdir -p " + trash)
        os.system("mv -f " + path + " " + trash)

class mpv_play(Command):
    def execute(self):
        path=str(self.fm.thisdir.get_selection()[0])
        path.replace('"', "")
        path.replace('$(', "")
        path.replace('`', "")
        path='"' + path + '"'

        cmd='mpv --really-quiet --input-ipc-server=/tmp/mpvsocket --title=mpv '

        vid_exts = [ '.mp4', '.webm', '.flv', '.gif', '.mpv' ]

        if not any(ext in path for ext in vid_exts):
            cmd = cmd + "--no-video "
            os.system("play " + path)
        else:
            os.system("pkill -9 mpv > /dev/null 2>&1 ; " + \
                    "pkill -9 mpd > /dev/null 2>&1 ; nohup " + \
                    cmd + path + " -- > /dev/null 2>&1 &")
