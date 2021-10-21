#!/usr/bin/python3
from selenium.webdriver import Chrome
from time import strftime
import time
from selenium import webdriver

url = "https://www.google.com/favicon.ico"

options = webdriver.ChromeOptions()
#  https://source.chromium.org/chromium/chromium/src/+/main:services/network/public/cpp/network_switches.cc?q=kHostResolverRules&ss=chromium
options.add_argument("--host-resovler-rules=MAP www.google.com 8.8.8.8")

driver = Chrome(chrome_options=options)
print("Request time: " + strftime("%Y-%m-%d %H:%M:%S\n"))
driver.get(url)
# driver.quit()

time.sleep(60)
# driver = Chrome()
print("Request time: " + strftime("%Y-%m-%d %H:%M:%S\n"))
driver.get(url)
# driver.quit()

time.sleep(60)
# driver = Chrome()
print("Request time: " + strftime("%Y-%m-%d %H:%M:%S\n"))
driver.get(url)
# driver.quit()

time.sleep(400)
# driver = Chrome()
print("Request time: " + strftime("%Y-%m-%d %H:%M:%S\n"))
driver.get(url)
driver.quit()
