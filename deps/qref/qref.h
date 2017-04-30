/*
  qref.h: Copyright (C) 1997,1998 Tadayoshi Funaba All rights reserved
  $Id: qref.h,v 1.4 2014-04-08 19:36:15+09 tadf Exp $
*/

typedef struct {
    int j;
    int y, yd, m, md, wd;
    int leap;
} QDATE;

extern void qref(int j, QDATE *q);
extern int rqref(QDATE *q);
