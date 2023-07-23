# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By
import datetime

# Start the browser and perform the test
def start ():
    print (timestamp() + 'Start the browser')
    # --uncomment when running in Azure DevOps.
    options = ChromeOptions()
    
    options.add_argument("--headless")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--no-sandbox")
    options.add_argument("--remote-debugging-port=9222")

    driver = webdriver.Chrome(options=options)
    # driver = webdriver.Chrome()

    # Login
    login(driver, 'standard_user', 'secret_sauce')

    # Add cart
    add_cart(driver)

    # Remove cart
    remove_cart(driver)

# Login method
def login (driver, user, password):
    print (timestamp() + 'Start loging in.')

    driver.get('https://www.saucedemo.com/')
    print (timestamp() + 'Browser started.')

    driver.find_element(By.CSS_SELECTOR, "input[id = 'user-name']").send_keys(user)
    print (timestamp() + 'User standard_user entered.')

    driver.find_element(By.CSS_SELECTOR, "input[id = 'password']").send_keys(password)
    print (timestamp() + 'Password secret_sauce entered.')

    driver.find_element(By.CSS_SELECTOR, "input[id = 'login-button']").click()
    print (timestamp() + 'Button clicked.')

    logoElements = driver.find_elements(By.CSS_SELECTOR, ".app_logo")
    assert len(logoElements) > 0, "Element not found"

    print (timestamp() + 'User successfully logged.')
    print (timestamp() + 'End login.')

# Add cart
def add_cart(driver):
    print (timestamp() + 'Start adding products to cart.')
    productElements = driver.find_elements(By.CSS_SELECTOR, ".inventory_item")

    for product in productElements:
        productButton = product.find_element(By.CSS_SELECTOR, ".btn_inventory")
        productName = product.find_element(By.CSS_SELECTOR, ".inventory_item_name")
        productButton.click()

        print(timestamp() + f"Product {productName.text} has been added to the cart.")

    cartCount = int(driver.find_element(By.CSS_SELECTOR, ".shopping_cart_badge").text)
    assert cartCount == len(productElements), 'The cart count does not correct'
    print(timestamp() + 'Verified the product in the cart.')
    
    print(timestamp() + 'Number of products in cart: ' + str(cartCount) + '.')
    print(timestamp() + 'Finish adding products.')

# Remove all product
def remove_cart(driver):
    print(timestamp() + 'Start remove products in the cart.')

    driver.find_element(By.CSS_SELECTOR, ".shopping_cart_link").click()
    print(timestamp() + 'Cart page opened.')

    
    removeButtons = driver.find_elements(By.CSS_SELECTOR, ".cart_button")
    for remove in removeButtons:
        remove.click()
        print(timestamp() + 'Removed product.')
    print(timestamp() + 'Removed all products.')

    cartCountElement = driver.find_elements(By.CSS_SELECTOR, ".shopping_cart_badge")
    assert len(cartCountElement) == 0, "Remove failed"
    print(timestamp() + 'Verified the product in the cart.')

    print(timestamp() + 'Finish removing the product.')

def timestamp():
    ts = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ")
    return (ts + ' ')

start()