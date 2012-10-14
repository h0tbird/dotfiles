// Compile with:
// gcc -Wall -pedantic -std=c99 -lX11 statusbar.c -o statusbar

//-----------------------------------------------------------------------------
// Includes:
//-----------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <X11/Xlib.h>
#include <errno.h>

//-----------------------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------------------

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
// getdatetime:
//-----------------------------------------------------------------------------

char *getdatetime()

{
    char *buf;
    time_t result;
    struct tm *resulttm;

    if((buf = malloc(sizeof(char)*65)) == NULL) {
        fprintf(stderr, "Cannot allocate memory for buf.\n");
        exit(1);
    }

    result = time(NULL);
    resulttm = localtime(&result);
    if(resulttm == NULL) {
        fprintf(stderr, "Error getting localtime.\n");
        exit(1);
    }

    if(!strftime(buf, sizeof(char)*65-1, "%a %d %b Ý %H:%M:%S ", resulttm)) {
        fprintf(stderr, "strftime is 0.\n");
        exit(1);
    }

    return buf;
}

//-----------------------------------------------------------------------------
// getbattery:
//-----------------------------------------------------------------------------

int getbattery()

{
    FILE *fd;
    int energy_now, energy_full, voltage_now;

    fd = fopen("/sys/class/power_supply/BAT0/energy_now", "r");
    if(fd == NULL) {
        fprintf(stderr, "Error opening energy_now.\n");
        return -1;
    }

    fscanf(fd, "%d", &energy_now);
    fclose(fd);

    fd = fopen("/sys/class/power_supply/BAT0/energy_full", "r");
    if(fd == NULL) {
        fprintf(stderr, "Error opening energy_full.\n");
        return -1;
    }

    fscanf(fd, "%d", &energy_full);
    fclose(fd);

    fd = fopen("/sys/class/power_supply/BAT0/voltage_now", "r");
    if(fd == NULL) {
        fprintf(stderr, "Error opening voltage_now.\n");
        return -1;
    }

    fscanf(fd, "%d", &voltage_now);
    fclose(fd);

    return ((float)energy_now * 1000 / (float)voltage_now) * 100 / ((float)energy_full * 1000 / (float)voltage_now);
}

//-----------------------------------------------------------------------------
// Entry point:
//-----------------------------------------------------------------------------

int main(void)

{
    char *status;
    char *datetime;
    int bat0;

    if (!(dpy = XOpenDisplay(NULL))) MyDBG(end0);
    if ((status = malloc(200)) == NULL) MyDBG(end0);

    while (1) {

        datetime = getdatetime();
        bat0 = getbattery();
        snprintf(status, 200, "\x04Ü\x06 Ã %d%% \x05Ü\x02 Õ %s", bat0, datetime);
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
