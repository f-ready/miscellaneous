# %% ######################################################################
###                                                                     ###
###                          Table of Contents                          ###
###                                                                     ###
###     0.          Dependent Libraries                                 ###
###     1.          Variable Initialization                             ###
###     z.          Clean Up                                            ###
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
import matplotlib.pyplot as plt, numpy as np, pandas as pd



# %% ######################################################################
###     1.          Variable Initialization                             ###
###########################################################################

pd.set_option("display.max_rows", None)
pd.set_option("display.max_columns", None)
pd.set_option("display.expand_frame_repr", False)
pd.set_option("max_colwidth", None)
pd.set_option("display.float_format", lambda x: "%.5f" % x)
pd.set_option("use_inf_as_na", True)
plt.style.use("tableau-colorblind10")

wrk_dir = os.getcwd()



# %% ######################################################################
###     z.          Clean Up                                            ###
###########################################################################

del wrk_dir
gc.collect()

os.system("cls 2> nul")
