// Compile with:
// gcc -Wall -pedantic -std=c99 -lX11 -D_BSD_SOURCE statusbar.c -o statusbar

//-----------------------------------------------------------------------------
// Includes:
//-----------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <X11/Xlib.h>
#include <errno.h>
#include <sys/types.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

//-----------------------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------------------

#define CMDLEN 32
#define MyDBG(x) do {printf("(%d) %s:%d\n", errno, __FILE__, __LINE__); goto x;} while (0)

//-----------------------------------------------------------------------------
// Globals:
//-----------------------------------------------------------------------------

static Display *dpy;

//-----------------------------------------------------------------------------
// setstatus:
//-----------------------------------------------------------------------------

void setstatus(char *str)

{
    XStoreName(dpy, DefaultRootWindow(dpy), str);
    XSync(dpy, False);
}

//-----------------------------------------------------------------------------
// getvmcount:
//-----------------------------------------------------------------------------

int getvmcount()

{
    DIR *dp;
    struct dirent *ep;
    char str[CMDLEN];
    int fd, c = 0;
    ssize_t r;
    unsigned n = 0;

    //------------
    // Open /proc
    //------------

    if((dp = opendir("/proc")) == NULL) MyDBG(end0);

    //----------------------------------
    // Loop through /proc/<pid>/cmdline
    //----------------------------------

    while((ep = readdir(dp))) { if(ep->d_type == DT_DIR) {

        if(snprintf(str, CMDLEN, "%d", atoi(ep->d_name)) < 0) MyDBG(end0);
        if(strcmp(str, ep->d_name) != 0) continue;
        if(snprintf(str, CMDLEN, "/proc/%s/cmdline", ep->d_name) < 0) MyDBG(end0);
        if((fd = open(str, O_RDONLY)) == -1) MyDBG(end0);

        //---------------
        // Read cmdline:
        //---------------

        n=0; str[0] = '\0'; while(1) {

            if((r = read(fd,str+n,CMDLEN-n)) == -1) {
                if(errno==EINTR) continue;
                break;
            }

            n += r;
            if(n==CMDLEN) break;
            if(r==0) break;
        }

        if(n==CMDLEN) n--;
        str[n] = '\0';
        close(fd);

        //---------------------------
        // Count qemu-system-x86_64:
        //---------------------------

        if(!strcmp(str, "qemu-system-x86_64")) c++;
    }}

    //--------------------
    // Return on success:
    //--------------------

    closedir(dp);
    return c;

    //------------------
    // Return on error:
    //------------------

    end0: return 0;
}

//-----------------------------------------------------------------------------
// getdatetime:
//-----------------------------------------------------------------------------

char *getdatetime()

{
    char *buf = NULL;
    time_t result = time(NULL);
    struct tm *resulttm = localtime(&result);

    if(resulttm == NULL) MyDBG(end0);
    if((buf = malloc(sizeof(char)*65)) == NULL) MyDBG(end0);
    if(!strftime(buf, sizeof(char)*65-1, "%a %d %b Ý %H:%M:%S ", resulttm)) MyDBG(end0);

    // Return on success:
    return buf;

    // Return on error:
    end0: return NULL;
}

//-----------------------------------------------------------------------------
// getbattery:
//-----------------------------------------------------------------------------

int getbattery()

{
    FILE *fd;
    int energy_now, energy_full, voltage_now;

    if((fd = fopen("/sys/class/power_supply/BAT0/energy_now", "r")) == NULL) MyDBG(end0);
    fscanf(fd, "%d", &energy_now);
    fclose(fd);

    if((fd = fopen("/sys/class/power_supply/BAT0/energy_full", "r")) == NULL) MyDBG(end0);
    fscanf(fd, "%d", &energy_full);
    fclose(fd);

    if((fd = fopen("/sys/class/power_supply/BAT0/voltage_now", "r")) == NULL) MyDBG(end0);
    fscanf(fd, "%d", &voltage_now);
    fclose(fd);

    // Return on success:
    return ((float)energy_now * 1000 / (float)voltage_now) * 100 / ((float)energy_full * 1000 / (float)voltage_now);

    // Return on error:
    end0: return -1;
}

//-----------------------------------------------------------------------------
// Entry point:
//-----------------------------------------------------------------------------

int main(void)

{
    char *status;
    char *datetime;
    int bat0, vmc;

    if(!(dpy = XOpenDisplay(NULL))) MyDBG(end0);
    if((status = malloc(200)) == NULL) MyDBG(end0);

    while(1) {

        datetime = getdatetime();
        bat0 = getbattery();
        vmc = getvmcount();

        if(vmc < 1) snprintf(status, 200, "\x04Ü\x06 Ã %d%% \x05Ü\x02 Õ %s", bat0, datetime);
        else snprintf(status, 200, "\x01Ý \x0CÍ %d \x04Ü\x06 Ã %d%% \x05Ü\x02 Õ %s", vmc, bat0, datetime);

        free(datetime);
        setstatus(status);
        sleep(1);
    }

    // Return on success:
    free(status);
    XCloseDisplay(dpy);
    return 0;

    // Return on error:
    end0: return 1;
}
