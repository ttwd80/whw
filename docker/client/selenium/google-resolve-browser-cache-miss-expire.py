#!/usr/bin/python3
from selenium.webdriver import Chrome
from time import strftime
import time

url = "https://www.google.com/favicon.ico"

driver = Chrome()
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
driver.quit()
