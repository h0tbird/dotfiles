// Compile with:
// gcc -Wall -pedantic -std=c99 -lX11 -D_DEFAULT_SOURCE statusbar.c -o statusbar

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
// getdatetime:
//-----------------------------------------------------------------------------

char *getdatetime()

{
    char *buf = NULL;
    time_t result = time(NULL);
    struct tm *resulttm = localtime(&result);

    if(resulttm == NULL) MyDBG(end0);
    if((buf = malloc(sizeof(char)*65)) == NULL) MyDBG(end0);
    if(!strftime(buf, sizeof(char)*65-1, "%a %d %b \xEE\x86\xAC%H:%M:%S", resulttm)) MyDBG(end0);

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
    int bat0;

    if(!(dpy = XOpenDisplay(NULL))) MyDBG(end0);
    if((status = malloc(200)) == NULL) MyDBG(end0);

    while(1) {

        datetime = getdatetime();
        bat0 = getbattery();

        // Siji iconic bitmap font:
        //
        // <UTF-8 encoding> | <Unicode value> | <Description>
        // --------------------------------------------------
        // \x04             | \u004           | Darkgrey on black
        // \xEE\x86\xAB     | \uE1AB          | Left arrow
        // \x06             | \u006           | Magenta on darkgrey
        // \xEE\x80\xB3     | \uE033          | Battery
        // \x05             | \u005           |
        // \xEE\x86\xAB     | \uE1AB          | Left arrow
        // \x02             | \u002           |
        // \xEE\x80\x95     | \uE015          | Clock

        snprintf(status, 200, "\x03| \x06\xEE\x80\xB3%d%% \x03| \x02\xEE\x80\x95%s        ", bat0, datetime);

	// Xbmicons iconic bitmap font:
	//
	// <UTF-8 encoding> | <Unicode value> | <Description>
	// --------------------------------------------------
	// \x04             | \u004           |
	// \xEE\x80\x9A     | \uE01A          | Left arrow
	// \x06             | \u006           |
	// \xEE\x80\x9F     | \uE01F          | Battery
	// \x05             | \u005           |
	// \xEE\x80\x9A     | \uE1AB          | Left arrow
	// \x02             | \u002           |
	// \xEE\x80\x96     | \uE016          | Clock

        // snprintf(status, 200, "\x04\xEE\x80\x9A\x06\xEE\x80\x9F%d%%\x05\xEE\x80\x9A\x02\xEE\x80\x96%s       ", bat0, datetime);

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
