#!/bin/bash

systemctl restart openibd
systemctl restart opensmd

systemctl enable openibd
chkconfig opensmd on
