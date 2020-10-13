require	'rubygems'
require	'selenium-webdriver'

username=ENV['BROWSERSTACK_USERNAME']
key=ENV['BROWSERSTACK_ACCESS_KEY']
url = "http://#{username}:#{key}@hub-cloud.browserstack.com/wd/hub"

#Input Capabilities
caps = Selenium::WebDriver::Remote::Capabilities.new
caps["os"] = "OS X"
caps["os_version"] = "Catalina"
caps["browser"] = "Safari"
caps["browser_version"] = "13.1"
caps["resolution"] = "1920x1080"
# caps["build"] = ENV['BROWSERSTACK_BUILD_NAME']
# caps["project"] = ENV['BROWSERSTACK_PROJECT_NAME']
caps["name"] = "Azure pipeline test"
# caps["browserstack.local"] = "true"
# caps["browserstack.localIdentifier"] = ENV['BROWSERSTACK_LOCAL_IDENTIFIER']
caps["browserstack.debug"] = "true"
caps["browserstack.networkLogs"] = "true"
caps["browserstack.timezone"] = "New York"
caps["browserstack.selenium_version"] = "4.0.0-alpha-2"


driver = Selenium::WebDriver.for(:remote,
	:url => url,
	:desired_capabilities => caps)

# driver.navigate.to "http://localhost:3000"
# puts driver.title
# driver.close()
# driver.quit()

# Setting name of the test
driver.execute_script('browserstack_executor: {"action": "setSessionName", "arguments": {"name": "Ruby test"}}')

# Searching for 'BrowserStack' on google.com
driver.navigate.to "http://www.google.com"
element = driver.find_element(:name, "q")
element.send_keys "BrowserStack"
element.submit

puts driver.title

# Setting the status of test as 'passed' or 'failed' based on the condition; if title of the web page matches 'BrowserStack - Google Search'
if driver.title=="BrowserStack - Google Search"
  driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"passed", "reason": "Title matched!"}}')
else
  driver.execute_script('browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"failed", "reason": "Title not matched"}}')
end

driver.quit
