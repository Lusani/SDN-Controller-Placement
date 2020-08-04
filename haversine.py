#!/usr/bin/env python
import math

def distance(source_destination):
    lat1, lon1 = source_destination[0]
    lat2, lon2 = source_destination[1]
    radius = 6371 

    dlat = math.radians(lat2-lat1)
    dlon = math.radians(lon2-lon1)
    a = math.sin(dlat/2) * math.sin(dlat/2) + math.cos(math.radians(lat1)) \
        * math.cos(math.radians(lat2)) * math.sin(dlon/2) * math.sin(dlon/2)
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
    d = (0.5*radius * c)/(10**2) #calculate delay by taking the ratio of distance to speed

    return d
