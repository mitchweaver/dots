#!/usr/bin/python3
import asyncio
import subprocess
from os import system

DATE=""
VPN=""
BAT=""
WIFI=""

def main():
    asyncio.get_event_loop().create_task(date())
    asyncio.get_event_loop().create_task(battery())
    asyncio.get_event_loop().create_task(wifi())
    asyncio.get_event_loop().run_forever()

async def date():
    global DATE
    while True:
        DATE = subprocess.check_output("sh date.sh", shell=True).decode('utf-8').rstrip()
        await xsetroot()
        await asyncio.sleep(60)

async def battery():
    global BAT
    while True:
        BAT = subprocess.check_output("sh battery-check.sh", shell=True).decode('utf-8').rstrip()
        await xsetroot()
        await asyncio.sleep(10)

async def wifi():
    global WIFI,VPN
    while True:
        WIFI = subprocess.check_output("sh wifi-check.sh iwn0", shell=True).decode('utf-8').rstrip()
        VPN = subprocess.check_output("sh vpn-check.sh", shell=True).decode('utf-8').rstrip()
        await xsetroot()
        await asyncio.sleep(3)

async def xsetroot():
    system("xsetroot -name " + "'" + \
   
    '[ ' + WIFI + ' ]' + '[ ' + BAT + ' ]' + '[ ' + VPN + ' ]' + '[ ' + DATE + ' ]' \
    
    + "'")

if __name__ == "__main__": main()
