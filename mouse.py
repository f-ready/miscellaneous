# %% ######################################################################
###                                                                     ###
###                          Table of Contents                          ###
###                                                                     ###
###     0.          Dependent Libraries                                 ###
###     1.          Variable Initialization                             ###
###     2.          Manipulation                                        ###
###                                                                     ###
###########################################################################
###                                                                     ###
###     Mouse manipulation with keyboard input.                         ###
###                                                                     ###
###########################################################################



# %% ######################################################################
###     0.          Dependent Libraries                                 ###
###########################################################################

import time, tqdm
import pyautogui
import random, string



# %% ######################################################################
###     1.          Variable Initialization                             ###
###########################################################################

x, y = pyautogui.size()
pyautogui.FAILSAFE = False
num_minutes = 5



# %% ######################################################################
###     2.          Manipulation                                        ###
###########################################################################

t0 = time.time()
for i in tqdm.tqdm(range(1, num_minutes + 1)):
    t1 = time.time()
    cnt = 0
    while (((t1 - t0) // 60) < i):
        t1 = time.time()
        cnt += 1
        pyautogui.moveTo(x * 0.4, y * 0.4, duration = 0.25)
        pyautogui.moveTo(x * 0.6, y * 0.6, duration = 0.25)
    random_char = random.choice(string.ascii_letters)
    pyautogui.write(f"Minute {i} : move-{cnt}, write-{random_char}. 2> nul\r\n")
    ## pyautogui.write == pyautogui.typewrite
    ## pyautogui.write calls pyautogui.press && failSafeCheck()
