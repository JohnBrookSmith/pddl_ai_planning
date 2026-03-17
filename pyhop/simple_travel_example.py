"""
The "travel from home to the park" example from my lectures.
Author: Dana Nau <nau@cs.umd.edu>, May 31, 2013
This file should work correctly in both Python 2.7 and Python 3.2.
"""

import pyhop

# The cost of a taxi ride is £1.50 plus 50p per mile
def taxi_rate(dist):
    return (1.5 + 0.5 * dist)

# The cost of a bus ride is 10p plus 10p per mile (cheap!)
def bus_rate(dist):
    return (0.1 + 0.1 * dist)

# Walking is free! Is the agent at x? If so, change the agent's location to y and return the new state; 
# If not, return False.
def walk(state,a,x,y):
    if state.loc[a] == x:
        state.loc[a] = y
        return state
    else: return False

# Is the agent at x? If so, change the agent's location to the corresponding bus stop and return the new state; 
# If not, return False. 
def walk_to_bus_stop(state,a,x,y):
    if state.loc[a] == x:
        state.loc[a] = state.bus_stops[x]
        return state
    else: return False

# Is the agent at a bus stop that serves the destination? 
# If so, change the agent's location to the destination and return the new state; 
# If not, return False.
def walk_to_destination(state,a,x,y):
    if state.bus_stops[y] and state.loc[a] == state.bus_stops[y]:
        state.loc[a] = y
        return state
    else: return False

# Change the taxi's location to x and return the new state.
def call_taxi(state,a,x):
    state.loc['taxi'] = x
    return state

# Change the bus's location to x and return the new state.
def wait_for_bus(state,a,x):
    state.loc['bus'] = x
    return state

# Is the bus at the same location as the agent and is the agent at x? 
# If so, change the bus and agent's location to the bus stop that serves the destination, 
# set the amount owed to the bus driver, and return the new state;
# If not, return False.
def ride_bus(state,a,x,y):
    if state.loc['bus']==x and state.loc[a]:
        state.loc['bus'] = state.bus_stops[y]
        state.loc[a] = state.bus_stops[y]
        state.owe[a] = bus_rate(state.dist[x][y])
        return state
    else: return False

# Is the taxi at the same location as the agent and is the agent at x? 
# If so, change the taxi and agent's location to y, set the amount owed to
# the taxi driver, and return the new state;
# If not, return False.
def ride_taxi(state,a,x,y):
    if state.loc['taxi']==x and state.loc[a]==x:
        state.loc['taxi'] = y
        state.loc[a] = y
        state.owe[a] = taxi_rate(state.dist[x][y])
        return state
    else: return False

# If the agent has enough cash to pay the taxi driver, reduce the agent's cash by the amount owed, 
# set the amount owed to 0, and return the new state;
# If not, return False.
def pay_taxi_driver(state,a):
    if state.cash[a] >= state.owe[a]:
        state.cash[a] = state.cash[a] - state.owe[a]
        state.owe[a] = 0
        return state
    else: return False

# If the agent has enough cash to pay the bus driver, reduce the agent's cash by the amount owed,
# set the amount owed to 0, and return the new state;
# If not, return False.
def pay_bus_driver(state,a):
    if state.cash[a] >= state.owe[a]:
        state.cash[a] = state.cash[a] - state.owe[a]
        state.owe[a] = 0
        return state
    else: return False

# Declare the operators to Pyhop. The first argument is the name of the operator, 
# and the second is a pointer to the function that implements it.
pyhop.declare_operators(walk, call_taxi, ride_taxi, pay_taxi_driver, pay_bus_driver, walk_to_bus_stop, walk_to_destination, ride_bus, wait_for_bus)
print('')
pyhop.print_operators()

# The method for travel is: if the distance is short, walk; if the agent has enough cash, take a taxi; otherwise, take the bus.

# If the distance from x to y is 2 miles or less, return a plan for walking there; otherwise, return False.
def travel_by_foot(state,a,x,y):
    if state.dist[x][y] <= 2:
        return [('walk',a,x,y)]
    return False

# If the agent has enough cash to pay the taxi driver, return a plan for taking a taxi; otherwise, return False.
def travel_by_taxi(state,a,x,y):
    if state.cash[a] >= taxi_rate(state.dist[x][y]):
        return [('call_taxi',a,x), ('ride_taxi',a,x,y), ('pay_taxi_driver',a)]
    return False

# If the agent has enough cash to pay the bus driver, return a plan for taking the bus; otherwise, return False.
def travel_by_bus(state,a,x,y):
    if state.cash[a] >= bus_rate(state.dist[x][y]):
        return [('walk_to_bus_stop',a,x, state.bus_stops[x]), ('wait_for_bus',a, state.bus_stops[x]), ('ride_bus',a,x,y), ('pay_bus_driver',a), ('walk_to_destination',a, state.bus_stops[y], y)]
    return False

# Declare the methods to Pyhop. The first argument is the name of the method, the second is a pointer to the function that implements it, and the rest of the arguments are the names of the arguments that will be passed to the function.
pyhop.declare_methods('travel',travel_by_foot,travel_by_taxi, travel_by_bus)

print('')
pyhop.print_methods()

# Create the initial state. 
state1 = pyhop.State('state1')
state1.loc = {'me':'home'}
state1.cash = {'me':5}
state1.owe = {'me':0}
state1.dist = {'home':{'park':8, 'bus_stop_home':1, 'shops':15}, 'park':{'home':8, 'shops':8, 'bus_stop_park':1}, 'shops':{'home':14, 'park': 8, 'bus_stop_shops': 1}}
state1.bus_stops = {'home':'bus_stop_home', 'park':'bus_stop_park', 'shops': 'bus_stop_shops'}

print("""
********************************************************************************
Call pyhop.pyhop(state1,[('travel','me','home','park')]) with different verbosity levels
********************************************************************************
""")

print("- If verbose=0 (the default), Pyhop returns the solution but prints nothing.\n")
pyhop.pyhop(state1,[('travel','me','home','park')])

print('- If verbose=1, Pyhop prints the problem and solution, and returns the solution:')
pyhop.pyhop(state1,[('travel','me','home','park')],verbose=1)

print('- If verbose=2, Pyhop also prints a note at each recursive call:')
pyhop.pyhop(state1,[('travel','me','home','park')],verbose=2)

print('- If verbose=3, Pyhop also prints the intermediate states:')
pyhop.pyhop(state1,[('travel','me','home','park')],verbose=3)