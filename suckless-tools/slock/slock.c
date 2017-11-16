#define _XOPEN_SOURCE 500
#if HAVE_SHADOW_H
#include <shadow.h>
#endif

#include <ctype.h>
#include <errno.h>
#include <pwd.h>
#include <stdarg.h>
#include <stdlib.h>
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <X11/keysym.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>

#if HAVE_BSD_AUTH
#include <login_cap.h>
#include <bsd_auth.h>
#endif

#define CMD_LENGTH 500

#define POWEROFF 0
#define USBOFF 0
#define STRICT_USBOFF 0
#define TWILIO_SEND 0
#define WEBCAM_SHOT 1
#define IMGUR_UPLOAD 0
#define PLAY_AUDIO 0
#define TRANSPARENT 0

char *g_pw = NULL;
int lock_tries = 0;

typedef struct {
  int screen;
  Window root, win;
  Pixmap pmap;
  unsigned long colors[2];
} Lock;

static Lock **locks;
static int nscreens;
static Bool running = True;

static void
die(const char *errstr, ...) {
  va_list ap;

  va_start(ap, errstr);
  vfprintf(stderr, errstr, ap);
  va_end(ap);
  exit(EXIT_FAILURE);
}

#ifdef __linux__
#include <fcntl.h>

static void
dontkillme(void) {
  errno = 0;
  int fd = open("/proc/self/oom_score_adj", O_WRONLY);

  if (fd < 0 && errno == ENOENT)
    return;

  if (fd < 0)
    goto error;

  if (write(fd, "-1000\n", 6) != 6) {
    close(fd);
    goto error;
  }

  if (close(fd) != 0)
    goto error;

  return;

error:
  fprintf(stderr, "cannot disable the OOM killer for this process\n");
  fprintf(stderr, "trying with sudo...\n");

  pid_t pid = getpid();

  char cmd[CMD_LENGTH];

  int r = snprintf(
    cmd,
    CMD_LENGTH,
    "echo -1000 | sudo -n tee /proc/%u/oom_score_adj > /dev/null 2>& 1",
    (unsigned int)pid
  );

  if (r >= 0 && r < CMD_LENGTH)
    system(cmd);
}
#endif

#ifndef HAVE_BSD_AUTH

static const char *
getpw(void) {
  const char *rval;
  struct passwd *pw;

  if (g_pw)
    return g_pw;

  errno = 0;
  pw = getpwuid(getuid());

  if (!pw) {
    if (errno)
      die("slock: getpwuid: %s\n", strerror(errno));
    else
      die("slock: cannot retrieve password entry\n");
  }

  endpwent();
  rval = pw->pw_passwd;

#if HAVE_SHADOW_H
  if (rval[0] == 'x' && rval[1] == '\0') {
    struct spwd *sp;
    sp = getspnam(getenv("USER"));
    if (!sp)
      die("slock: cannot retrieve shadow entry\n");
    endspent();
    rval = sp->sp_pwdp;
  }
#endif

  // drop privileges
  if (geteuid() == 0) {
    if (!(getegid() != pw->pw_gid && setgid(pw->pw_gid) < 0)) {
      if (setuid(pw->pw_uid) < 0)
        die("slock: cannot drop privileges\n");
    }
  }

  return rval;
}
#endif

static char *
read_file(char *name) {
  FILE *f = fopen(name, "r");

  if (f == NULL)
    goto error;

  struct stat s;

  if (stat(name, &s) == -1) {
    fclose(f);
    goto error;
  }

  char *buf = malloc(s.st_size);

  if (buf == NULL) {
    fclose(f);
    goto error;
  }

  fread(buf, 1, s.st_size, f);
  fclose(f);

  char *c = buf;
  while (*c) {
    if (*c == '\r' || *c == '\n') {
      *c = '\0';
      break;
    }
    c++;
  }

  return buf;

error:
    fprintf(stderr, "Could not open: %s.\n", name);
    return NULL;
}

// Disable alt+sysrq and crtl+alt+backspace - keeps the
// attacker from alt+sysrq+k'ing our process
static void
disable_kill(void) {
#if POWEROFF
  // Needs sudo privileges - alter your /etc/sudoers file:
  // [username] [hostname] =NOPASSWD: /usr/bin/tee /proc/sys/kernel/sysrq
  // Needs sudo privileges - alter your /etc/sudoers file:
  // [username] [hostname] =NOPASSWD:
  // /usr/bin/tee /proc/sys/kernel/sysrq,/usr/bin/tee /proc/sysrq-trigger
  // system("echo 1 | sudo -n tee /proc/sys/kernel/sysrq > /dev/null");
  // system("echo o | sudo -n tee /proc/sysrq-trigger > /dev/null");
  system("echo 0 | sudo -n tee /proc/sys/kernel/sysrq > /dev/null 2>& 1 &");
  // Disable ctrl+alt+backspace
  system("setxkbmap -option &");
#else
  return;
#endif
}

// Poweroff if we're in danger.
static void
poweroff(void) {
#if POWEROFF
  // Needs sudo privileges - alter your /etc/sudoers file:
  // systemd: [username] [hostname] =NOPASSWD: /usr/bin/systemctl poweroff
  // sysvinit: [username] [hostname] =NOPASSWD: /usr/bin/shutdown -h now
  system("sudo -n systemctl poweroff 2> /dev/null");
  system("sudo -n shutdown -h now 2> /dev/null");
#else
  return;
#endif
}

// Turn USB off on lock.
static void
usboff(void) {
#if USBOFF
  // Needs sudo privileges - alter your /etc/sudoers file:
  // [username] [hostname] =NOPASSWD:
  // /sbin/sysctl kernel.grsecurity.deny_new_usb=1
  system("sudo -n sysctl kernel.grsecurity.deny_new_usb=1 2> /dev/null");
#if STRICT_USBOFF
  system("sudo -n sysctl kernel.grsecurity.grsec_lock=1 2> /dev/null");
#endif
#else
  return;
#endif
}

// Turn on USB when the correct password is entered.
static void
usbon(void) {
#if USBOFF
  // Needs sudo privileges - alter your /etc/sudoers file:
  // [username] [hostname] =NOPASSWD:
  // /sbin/sysctl kernel.grsecurity.deny_new_usb=0
  system("sudo -n sysctl kernel.grsecurity.deny_new_usb=0 2> /dev/null");
#else
  return;
#endif
}

// Take a screenshot of whoever is at the keyboard.
static int
webcam_shot(int async) {
#if WEBCAM_SHOT
  char cmd[CMD_LENGTH];

  int r = snprintf(
    cmd,
    CMD_LENGTH,
    "ffmpeg -y -loglevel quiet -f video4linux2 -i /dev/video0"
    " -frames:v 1 -f image2 %s/SLOCK-INTRUDER-\"$(date)\".jpg%s",
    getenv("HOME"),
    async ? " &" : ""
  );

  if (r < 0 || r >= CMD_LENGTH)
    return 0;

  system(cmd);

  return 1;
#else
  return 0;
#endif
}

// Send an SMS via twilio.
static int
twilio_send(const char *msg, char *link, int async) {
#if TWILIO_SEND
  char cmd[CMD_LENGTH];

  // Send the SMS/MMS via Twilio
  int r = snprintf(
    cmd,
    CMD_LENGTH,
    "curl -s -A '' -X POST https://api.twilio.com/2010-04-01/Accounts/"
    TWILIO_ACCOUNT "/SMS/Messages.json"
    " -u " TWILIO_AUTH
    " --data-urlencode 'From=" TWILIO_FROM "'"
    " --data-urlencode 'To=" TWILIO_TO "'"
    " --data-urlencode 'Body=%s'"
    " --data-urlencode 'MediaUrl=%s' > /dev/null"
    "%s",
    msg,
    link != NULL ? link : "",
    async ? " &" : ""
  );

  if (r < 0 || r >= CMD_LENGTH)
    return 0;

  system(cmd);

  return 1;
#else
  return 0;
#endif
}

// Upload image for MMS.
static int
imgur_upload(char **link, char **hash) {
  *link = NULL;
  *hash = NULL;

#if IMGUR_UPLOAD
  const char *HOME = getenv("HOME");
  char cmd[CMD_LENGTH];
  int r;

  // Upload the imgur image:
  r = snprintf(
    cmd,
    CMD_LENGTH,
    "curl -s -A '' -X POST"
    " -H 'Authorization: Client-ID " IMGUR_CLIENT "'"
    " -F 'image=@%s/slock.jpg'"
    " 'https://api.imgur.com/3/image' > %s/slock_imgur.curl",
    HOME,
    HOME
  );

  if (r < 0 || r >= CMD_LENGTH)
    goto cleanup;

  system(cmd);

  // Get the link:
  r = snprintf(
    cmd,
    CMD_LENGTH,
    "cat %s/slock_imgur.curl"
    " | grep -o '\"link\":\"[^\"]\\+'"
    " | sed 's/\\\\//g'"
    " | grep -o '[^\"]\\+$'"
    " > %s/slock_imgur.link",
    HOME,
    HOME
  );

  if (r < 0 || r >= CMD_LENGTH)
    goto cleanup;

  system(cmd);

  // Get the hash:
  r = snprintf(
    cmd,
    CMD_LENGTH,
    "cat %s/slock_imgur.curl"
    " | grep -o '\"deletehash\":\"[^\"]\\+'"
    " | grep -o '[^\"]\\+$'"
    " > %s/slock_imgur.hash",
    HOME,
    HOME
  );

  if (r < 0 || r >= CMD_LENGTH)
    goto cleanup;

  system(cmd);

  r = snprintf(cmd, CMD_LENGTH, "%s/slock_imgur.link", HOME);

  if (r < 0 || r >= CMD_LENGTH)
    goto cleanup;

  *link = read_file(cmd);

  r = snprintf(cmd, CMD_LENGTH, "%s/slock_imgur.hash", HOME);

  if (r < 0 || r >= CMD_LENGTH)
    goto cleanup;

  *hash = read_file(cmd);

cleanup:
  r = snprintf(cmd, CMD_LENGTH, "%s/slock_imgur.curl", HOME);

  if (r >= 0 && r < CMD_LENGTH)
    unlink(cmd);

  r = snprintf(cmd, CMD_LENGTH, "%s/slock_imgur.link", HOME);

  if (r >= 0 && r < CMD_LENGTH)
    unlink(cmd);

  r = snprintf(cmd, CMD_LENGTH, "%s/slock_imgur.hash", HOME);

  if (r >= 0 && r < CMD_LENGTH)
    unlink(cmd);

  if (*link == NULL || *hash == NULL) {
    if (*link != NULL)
      free(*link);
    if (*hash != NULL)
      free(*hash);
    return 0;
  }

  return 1;
#else
  return 0;
#endif
}

// Delete image once MMS is sent.
static int
imgur_delete(char *hash) {
#if IMGUR_UPLOAD
  char cmd[CMD_LENGTH];

  // Delete the imgur image:
  int r = snprintf(
    cmd,
    CMD_LENGTH,
    "curl -s -A '' -X DELETE"
    " -H 'Authorization: Client-ID " IMGUR_CLIENT "'"
    " 'https://api.imgur.com/3/image/%s'",
    hash
  );

  if (r < 0 || r >= CMD_LENGTH)
    return 0;

  system(cmd);

  return 1;
#else
  return 0;
#endif
}

static int
play_beep(int async) {
#if PLAY_AUDIO
  char cmd[CMD_LENGTH];

  int r = snprintf(
    cmd,
    CMD_LENGTH,
    "aplay %s/slock/beep.wav 2> /dev/null%s",
    getenv("HOME"),
    async ? " &" : ""
  );

  if (r >= 0 && r < CMD_LENGTH)
    system(cmd);

  return 1;
#else
  return 0;
#endif
}

static int
play_alarm(int async) {
#if PLAY_AUDIO
  char cmd[CMD_LENGTH];

  int r = snprintf(
    cmd,
    CMD_LENGTH,
    "aplay %s/slock/police.wav 2> /dev/null%s",
    getenv("HOME"),
    async ? " &" : ""
  );

  if (r >= 0 && r < CMD_LENGTH)
    system(cmd);

  return 1;
#else
  return 0;
#endif
}

static void
#ifdef HAVE_BSD_AUTH
readpw(Display *dpy)
#else
readpw(Display *dpy, const char *pws)
#endif
{
  char buf[32], passwd[256];
  int num, screen;
  unsigned int len = 0;
#if !TRANSPARENT
  unsigned int llen = 0;
#endif
  KeySym ksym;
  XEvent ev;

  running = True;

  // As "slock" stands for "Simple X display locker", the DPMS settings
  // had been removed and you can set it with "xset" or some other
  // utility. This way the user can easily set a customized DPMS
  // timeout.
  while (running && !XNextEvent(dpy, &ev)) {
    if (ev.type != KeyPress) {
      for (screen = 0; screen < nscreens; screen++)
        XRaiseWindow(dpy, locks[screen]->win);
      continue;
    }

    buf[0] = 0;

    num = XLookupString(&ev.xkey, buf, sizeof(buf), &ksym, 0);

    if (IsKeypadKey(ksym)) {
      if (ksym == XK_KP_Enter)
        ksym = XK_Return;
      else if (ksym >= XK_KP_0 && ksym <= XK_KP_9)
        ksym = (ksym - XK_KP_0) + XK_0;
    }

    if (IsFunctionKey(ksym)
        || IsKeypadKey(ksym)
        || IsMiscFunctionKey(ksym)
        || IsPFKey(ksym)
        || IsPrivateKeypadKey(ksym)) {
      continue;
    }

    switch(ksym) {
      case XK_Return: {
        passwd[len] = 0;

        if (g_pw) {
          running = strcmp(passwd, g_pw) != 0;
        } else {
#ifdef HAVE_BSD_AUTH
          running = !auth_userokay(getlogin(), NULL, "auth-xlock", passwd);
#else
          running = strcmp(crypt(passwd, pws), pws) != 0;
#endif
        }

        if (running) {
          XBell(dpy, 100);
          lock_tries++;

          // Poweroff if there are more than 5 bad attempts.
          if (lock_tries > 5) {
            // Disable alt+sysrq and ctrl+alt+backspace
            disable_kill();

            // Take a webcam shot of whoever is tampering with our machine:
            webcam_shot(0);

            // Upload the image:
            char *link, *hash;
            int success = imgur_upload(&link, &hash);

            // Send an SMS/MMS via twilio.
            twilio_send("Bad screenlock password.", link, 0);

            // Success. Cleanup.
            if (success) {
              // Delete the image from imgur.
              imgur_delete(hash);

              free(link);
              free(hash);
            }

            // Immediately poweroff:
            poweroff();

            // If we failed, loop forever.
            for (;;)
              sleep(1);
          } else {
            // Take a webcam shot of whoever
            // is tampering with our machine.
            webcam_shot(1);

            // Send an SMS via twilio.
            twilio_send("Bad screenlock password.", NULL, 1);
          }

          // Play a siren if there are more than 2 bad
          // passwords, a beep if a correct password.
          if (lock_tries > 2) {
            play_alarm(0);
          } else {
            play_beep(0);
          }
        }

        len = 0;

        break;
      }
      case XK_Escape: {
        len = 0;
        break;
      }
      case XK_Delete:
      case XK_BackSpace: {
        if (len)
          len -= 1;
        break;
      }
      case XK_Alt_L:
      case XK_Alt_R:
      case XK_Control_L:
      case XK_Control_R:
      case XK_Meta_L:
      case XK_Meta_R:
      case XK_Super_L:
      case XK_Super_R:
      case XK_F1:
      case XK_F2:
      case XK_F3:
      case XK_F4:
      case XK_F5:
      case XK_F6:
      case XK_F7:
      case XK_F8:
      case XK_F9:
      case XK_F10:
      case XK_F11:
      case XK_F12:
      case XK_F13: {
        // Disable alt+sysrq and ctrl+alt+backspace.
        disable_kill();

        // Take a webcam shot of whoever
        // is tampering with our machine.
        webcam_shot(0);

        // Upload our image:
        char *link, *hash;
        int success = imgur_upload(&link, &hash);

        // Send an SMS/MMS via twilio.
        twilio_send("Bad screenlock key.", link, 0);

        // Success. Cleanup.
        if (success) {
          // Delete the image from imgur.
          imgur_delete(hash);

          free(link);
          free(hash);
        }

        // Immediately poweroff:
        poweroff();

        // If we failed, loop forever.
        for (;;)
          sleep(1);

        break;
      }
      default: {
        if (num && !iscntrl((int)buf[0]) && (len + num < sizeof(passwd))) {
          memcpy(passwd + len, buf, num);
          len += num;
        }
        break;
      }
    }

#if !TRANSPARENT
    if (llen == 0 && len != 0) {
      for (screen = 0; screen < nscreens; screen++) {
        XSetWindowBackground(
          dpy,
          locks[screen]->win,
          locks[screen]->colors[1]
        );
        XClearWindow(dpy, locks[screen]->win);
      }
    } else if (llen != 0 && len == 0) {
      for (screen = 0; screen < nscreens; screen++) {
        XSetWindowBackground(
          dpy,
          locks[screen]->win,
          locks[screen]->colors[0]
        );
        XClearWindow(dpy, locks[screen]->win);
      }
    }

    llen = len;
#endif
  }
}

static void
unlockscreen(Display *dpy, Lock *lock) {
  usbon();

  if (dpy == NULL || lock == NULL)
    return;

  XUngrabPointer(dpy, CurrentTime);

#if !TRANSPARENT
  XFreeColors(dpy, DefaultColormap(dpy, lock->screen), lock->colors, 2, 0);
  XFreePixmap(dpy, lock->pmap);
#endif

  XDestroyWindow(dpy, lock->win);

  free(lock);
}

static Lock *
lockscreen(Display *dpy, int screen) {
  unsigned int len;
  Lock *lock;
  XSetWindowAttributes wa;

  if (dpy == NULL || screen < 0)
    return NULL;

  lock = malloc(sizeof(Lock));

  if (lock == NULL)
    return NULL;

  lock->screen = screen;

  lock->root = RootWindow(dpy, lock->screen);

#if TRANSPARENT
  XVisualInfo vi;
  XMatchVisualInfo(dpy, DefaultScreen(dpy), 32, TrueColor, &vi);
  wa.colormap = XCreateColormap(
    dpy,
    DefaultRootWindow(dpy),
    vi.visual,
    AllocNone
  );
#endif

  // init
  wa.override_redirect = 1;
#if !TRANSPARENT
  wa.background_pixel = BlackPixel(dpy, lock->screen);
#else
  wa.border_pixel = 0;
  wa.background_pixel = 0xaa000000;
#endif

#if !TRANSPARENT
  int field = CWOverrideRedirect | CWBackPixel;
  lock->win = XCreateWindow(
    dpy,
    lock->root,
    0,
    0,
    DisplayWidth(dpy, lock->screen),
    DisplayHeight(dpy, lock->screen),
    0,
    DefaultDepth(dpy, lock->screen),
    CopyFromParent,
    DefaultVisual(dpy, lock->screen),
    field,
    &wa
  );
#else
  int field = CWOverrideRedirect | CWBackPixel | CWColormap | CWBorderPixel;
  lock->win = XCreateWindow(
    dpy,
    lock->root,
    0,
    0,
    DisplayWidth(dpy, lock->screen),
    DisplayHeight(dpy, lock->screen),
    0,
    vi.depth,
    CopyFromParent,
    vi.visual,
    field,
    &wa
  );
#endif

  Atom name_atom = XA_WM_NAME;
  XTextProperty name_prop = { "slock", name_atom, 8, 5 };
  XSetWMName(dpy, lock->win, &name_prop);

  XClassHint *hint = XAllocClassHint();
  if (hint) {
    hint->res_name = "slock";
    hint->res_class = "slock";
    XSetClassHint(dpy, lock->win, hint);
    XFree(hint);
  }

#if !TRANSPARENT
  Cursor invisible;
  XColor color, dummy;
  char curs[] = {0, 0, 0, 0, 0, 0, 0, 0};
  int cmap = DefaultColormap(dpy, lock->screen);

  XAllocNamedColor(dpy, cmap, COLOR2, &color, &dummy);
  lock->colors[1] = color.pixel;

  XAllocNamedColor(dpy, cmap, COLOR1, &color, &dummy);
  lock->colors[0] = color.pixel;

  lock->pmap = XCreateBitmapFromData(dpy, lock->win, curs, 8, 8);

  invisible = XCreatePixmapCursor(
    dpy, lock->pmap, lock->pmap, &color, &color, 0, 0);

  XDefineCursor(dpy, lock->win, invisible);
#endif

  XMapRaised(dpy, lock->win);

  for (len = 1000; len > 0; len--) {
    int field = ButtonPressMask | ButtonReleaseMask | PointerMotionMask;

#if !TRANSPARENT
    int grab = XGrabPointer(
      dpy,
      lock->root,
      False,
      field,
      GrabModeAsync,
      GrabModeAsync,
      None,
      invisible,
      CurrentTime
    );
#else
    int grab = XGrabPointer(
      dpy,
      lock->root,
      False,
      field,
      GrabModeAsync,
      GrabModeAsync,
      None,
      None,
      CurrentTime
    );
#endif

    if (grab == GrabSuccess)
      break;

    usleep(1000);
  }

  if (running && (len > 0)) {
    for (len = 1000; len; len--) {
      int grab = XGrabKeyboard(
        dpy,
        lock->root,
        True,
        GrabModeAsync,
        GrabModeAsync,
        CurrentTime
      );

      if (grab == GrabSuccess)
        break;

      usleep(1000);
    }
  }

  running &= (len > 0);

  if (!running) {
    unlockscreen(dpy, lock);
    lock = NULL;
  } else {
    XSelectInput(dpy, lock->root, SubstructureNotifyMask);
    usboff();
  }

  return lock;
}

static void
usage(void) {
  fprintf(stderr, "usage: slock [-v]\n");
  exit(EXIT_FAILURE);
}

static char *
read_pw_file(void) {
  char name[256];

  int r = snprintf(
    name,
    sizeof(name),
    "%s/.slock_passwd",
    getenv("HOME")
  );

  if (r < 0 || r >= sizeof(name))
    return NULL;

  return read_file(name);
}

int
main(int argc, char **argv) {
#ifndef HAVE_BSD_AUTH
  const char *pws;
#endif
  Display *dpy;
  int screen;

#ifdef SLOCK_QUIET
  freopen("/dev/null", "a", stdout);
  freopen("/dev/null", "a", stderr);
#endif

  g_pw = read_pw_file();

  if ((argc >= 2) && strcmp(argv[1], "-v") == 0) {
    die("slock-%s, © 2006-2012 Anselm R Garbe\n", VERSION);
  } else if (argc != 1) {
    usage();
  }

#ifdef __linux__
  dontkillme();
#endif

  if (!g_pw && !getpwuid(getuid()))
    die("slock: no passwd entry for you\n");

#ifndef HAVE_BSD_AUTH
  pws = getpw();
#endif

  dpy = XOpenDisplay(0);
  if (!dpy)
    die("slock: cannot open display\n");

  // Get the number of screens in display "dpy" and blank them all.
  nscreens = ScreenCount(dpy);

  errno = 0;
  locks = malloc(sizeof(Lock *) * nscreens);

  if (locks == NULL)
    die("slock: malloc: %s\n", strerror(errno));

  int nlocks = 0;

  for (screen = 0; screen < nscreens; screen++) {
    locks[screen] = lockscreen(dpy, screen);
    if (locks[screen] != NULL)
      nlocks++;
  }

  XSync(dpy, False);

  // Did we actually manage to lock something?
  if (nlocks == 0) { // nothing to protect
    free(locks);
    XCloseDisplay(dpy);
    return 1;
  }

  // Everything is now blank. Now wait for the correct password.
#ifdef HAVE_BSD_AUTH
  readpw(dpy);
#else
  readpw(dpy, pws);
#endif

  // Password ok, unlock everything and quit.
  for (screen = 0; screen < nscreens; screen++)
    unlockscreen(dpy, locks[screen]);

  free(locks);
  XCloseDisplay(dpy);

  return 0;
}
