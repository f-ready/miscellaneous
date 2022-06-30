# %% ######################################################################
###                                                                     ###
###                          Table of Contents                          ###
###                                                                     ###
###     0.          Dependent Libraries                                 ###
###     1.0.        Data - Context                                      ###
###     1.1.        Data - Structure                                    ###
###     1.2.        Data - Organization                                 ###
###     2.          Search                                              ###
###     z.          Miscellaneous                                       ###
###                                                                     ###
###########################################################################
###                                                                     ###
###     A recursive search looking for the smallest subset              ###
###     that contains all of the known elements.                        ###
###                                                                     ###
###     Approach is based on the solution to the knapsack problem,      ###
###     and other variants in integer programming.                      ###
###                                                                     ###
###########################################################################



# %% ######################################################################
###     0.          Dependent Libraries                                 ###
###########################################################################

import copy



# %% ######################################################################
###     1.0.        Data - Context                                      ###
###########################################################################

### Should be w, x, y

# - a b c d e f g
# t - x x - - - x
# u x x x x - - -
# v x - - - x - -
# w x - x x - x -
# x - x - - x x -
# y - - - x x - x
# z - x - - - - -



# %% ######################################################################
###     1.1.        Data - Structure                                    ###
###########################################################################

d_x_y = {
    "t" : ["b", "c", "g"],
    "u" : ["a", "b", "c", "d"],
    "v" : ["a", "e"],
    "w" : ["a", "c", "d", "f"],
    "x" : ["b", "e", "f"],
    "y" : ["d", "e", "g"],
    "z" : ["b"],
    }

# d_y_x = {
#     "a": ["u", "v", "w"],
#     "b": ["t", "u", "x", "z"],
#     "c": ["t", "u", "w"],
#     "d": ["u", "w", "y"],
#     "e": ["v", "x", "y"],
#     "f": ["w", "x"],
#     "g": ["t", "y"],}

def reverse_dict(d):
    d_reverse = {}
    for k in d.keys():
        for v in d[k]:
            if (v not in d_reverse.keys()):
                d_reverse[v] = []
            d_reverse[v] += [k]
    return(d_reverse)

def gather_dict(d):
    d_gather = {}
    for k in d.keys():
        v = d[k]
        if (v not in d_gather.keys()):
            d_gather[v] = []
        d_gather[v] += [k]
    return(d_gather)

# d_y_x = reverse_dict(d_x_y)



# %% ######################################################################
###     1.2.        Data - Organization                                 ###
###########################################################################

### Want a subset of t-z that covers as many of a-g as possible.

def remove_k(d, k):
    d_new = copy.deepcopy(d)
    vs = d_new.pop(k)
    return(d_new, vs)

def remove_v(d, v):
    d_new = copy.deepcopy(d)
    ks = []
    for k in list(d_new.keys()):
        if (v in d_new[k]):
            if (len(d_new[k]) == 1):
                d_new.pop(k)
            else:
                d_new[k].remove(v)
            ks.append(k)
    return(d_new, ks)



# %% ######################################################################
###     2.          Search                                              ###
###########################################################################

def minimal_spanning_subset(d, v_hash):
    ###
    ### Terminate the leaf node.
    if (len(d.keys()) == 0):
        return(v_hash)
    ###
    ### Subdivide the search.
    k_iter = list(d.keys())[0]
    d_iter, v_iter = remove_k(d, k_iter)
    ###
    ### Case 1 : Exclusion.
    hash_exc = minimal_spanning_subset(d_iter, v_hash)
    ###
    ### Case 2 : Inclusion.
    v_hash_inc = copy.deepcopy(v_hash)
    for v in v_iter:
        d_iter, k = remove_v(d_iter, v)
        if (v not in v_hash_inc.keys()):
            v_hash_inc[v] = k_iter
    hash_inc = minimal_spanning_subset(d_iter, v_hash_inc)
    ###
    ### Compare the cases.
    value_exc = len(hash_exc.keys())
    value_inc = len(hash_inc.keys())
    if (value_exc > value_inc):
        return(hash_exc)
    elif (value_exc < value_inc):
        return(hash_inc)
    else:
        cost_exc = len(set(hash_exc.values()))
        cost_inc = len(set(hash_inc.values()))
        if (cost_exc < cost_inc):
            return(hash_exc)
        elif (cost_exc > cost_inc):
            return(hash_inc)
        else:
            return(hash_inc)



# %% ######################################################################
###     z.          Miscellaneous                                       ###
###########################################################################

span_subset = minimal_spanning_subset(d_x_y, {})
gather_dict(span_subset)
