import pyautogui
import time

print("Move your mouse to the target location. Coordinates will be printed every second.")
print("Press Ctrl+C to quit.")

try:
    while True:
        x, y = pyautogui.position()
        positionStr = 'X: ' + str(x).rjust(4) + ' Y: ' + str(y).rjust(4)
        print(positionStr, end='')
        print('\b' * len(positionStr), end='', flush=True)
        time.sleep(1)
except KeyboardInterrupt:
    print('\nDone.')