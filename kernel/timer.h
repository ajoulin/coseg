#ifndef __TIMER_H__
#define __TIMER_H__

#include <sys/time.h> 
#include <unistd.h>

#include "output.h"

typedef struct timeval Timer;

// Display time
#define DISPTIME(time) 	if(time >= 1)\
                            myprintf("%s:%d: timer: %lf s\n", __FILE__, __LINE__, time);\
                        else if(time >= 0.001)\
                            myprintf("%s:%d: timer: %lf ms\n", __FILE__, __LINE__, time * 1000.);\
                        else\
                            myprintf("%s:%d: timer: %lf µs\n", __FILE__, __LINE__, time *1e6);
               
// equivalent to "tic()"
#define TIC(timer)      gettimeofday(&timer, NULL);

// equivalent to "time = toc();"
#define TOC(timer, time){\
                            double __t1__ = (double)timer.tv_sec + ((double)timer.tv_usec) * 1e-6;\
                            gettimeofday(&timer, NULL);\
                            time = (double)timer.tv_sec + ((double)timer.tv_usec) * 1e-6 - __t1__;\
                        }

// equivalent to "time = time + toc()"
#define ADDTOC(timer, time) {\
                                double __t1__ = (double)timer.tv_sec + ((double)timer.tv_usec) * 1e-6;\
                                gettimeofday(&timer, NULL);\
                                time += (double)timer.tv_sec + ((double)timer.tv_usec) * 1e-6 - __t1__;\
                            }                    
                        
// equivalent to "toc()"
#define DISPTOC(timer)  {\
                            double __t__;\
                            TOC(timer, __t__)\
                            DISPTIME(__t__)\
                        }

#endif
