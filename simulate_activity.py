# %% ######################################################################
###                                                                     ###
###                          Table of Contents                          ###
###                                                                     ###
###     0.          Dependent Libraries                                 ###
###     1.          Variable Initialization                             ###
###     2.          Simulate Activity                                   ###
###                                                                     ###
###########################################################################
###                                                                     ###
###     Moves mouse to prevevnt inactivity.                             ###
###     Presses keystrokes to prevent inactivity.                       ###
###                                                                     ###
###########################################################################



# %% ######################################################################
###     0.          Dependent Libraries                                 ###
###########################################################################

import pyautogui
import random, string, time



# %% ######################################################################
###     1.          Variable Initialization                             ###
###########################################################################

x, y = pyautogui.size()
pyautogui.FAILSAFE = False
count = 0



# %% ######################################################################
###     2.          Simulate Activity                                   ###
###########################################################################

print("Moving mouse.")
while(True):
    count += 1
    pyautogui.moveTo(1 * x/4, 1 * y/4, duration = 1)
    pyautogui.moveTo(3 * x/4, 3 * y/4, duration = 1)
    if (count == 60):
        count = 0
        random_char = random.choice(string.ascii_letters)
        pyautogui.write(f"Refresh selection with typewrite : {random_char}.\r\n")
        ### pyautogui.write == pyautogui.typewrite
        ### pyautogui.write calls pyautogui.press && failSafeCheck()
