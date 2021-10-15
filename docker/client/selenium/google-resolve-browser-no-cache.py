#!/usr/bin/python3
from selenium.webdriver import Chrome
from time import strftime
import time

driver = Chrome()
url = "https://www.google.com/favicon.ico"
print("Request time: " + strftime("%Y-%m-%d %H:%M:%S\n"))
driver.get(url)
driver.quit()

driver = Chrome()
time.sleep(55)
print("Request time: " + strftime("%Y-%m-%d %H:%M:%S\n"))
driver.get(url)
driver.quit()

driver = Chrome()
time.sleep(10)
print("Request time: " + strftime("%Y-%m-%d %H:%M:%S\n"))
driver.get(url)
driver.quit()
