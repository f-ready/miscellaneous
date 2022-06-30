# %% ######################################################################
###                                                                     ###
###                          Table of Contents                          ###
###                                                                     ###
###     0.0.        Dependent Libraries                                 ###
###     0.          Dependent Libraries                                 ###
###     1.          Variable Initialization                             ###
###     z.          Clean Up                                            ###
###     z.          Miscellaneous                                       ###
###                                                                     ###
###########################################################################
###                                                                     ###
###     Short Explanation.                                              ###
###                                                                     ###
###########################################################################



# %% ######################################################################
###     0.          Dependent Libraries                                 ###
###########################################################################

import gc, os, sys
import pandas as pd
pd.set_option("display.max_rows", None)
pd.set_option("display.max_columns", None)
pd.set_option("display.expand_frame_repr", False)



# %% ######################################################################
###     1.          Variable Initialization                             ###
###########################################################################

wrk_dir = os.getcwd()



# %% ######################################################################
###     z.          Clean Up                                            ###
###########################################################################

del wrk_dir
gc.collect()
os.system("cls 2> nul")
