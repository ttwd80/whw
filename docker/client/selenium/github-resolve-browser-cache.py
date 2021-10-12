#!/usr/bin/python3
from selenium.webdriver import Chrome
from time import strftime
import time

driver = Chrome()
print(strftime("%Y-%m-%d %H:%M:%S\n"))
driver.get("https://github.com/")
time.sleep(55)
print(strftime("%Y-%m-%d %H:%M:%S\n"))
driver.get("https://github.com/")
time.sleep(10)
print(strftime("%Y-%m-%d %H:%M:%S\n"))
driver.get("https://github.com/")
driver.quit()
