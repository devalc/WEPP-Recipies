# -*- coding: utf-8 -*-
"""
#Created on Fri May 15 16:22:51 2020
#
# script to extract all the soil realted variables and
#  summarize all soil horizon variables files from a given run by calculating
# depth weighted average for each individual hillslope
#
#
#@author: Chinmay Deval, some funcs taken from github
"""
from glob import glob
import os, shlex
import pandas as pd
import numpy as np
#--------------------------------------------------------------------------------------------------

path = "C:\\Users\\Chinmay\\Desktop\\test_sol\\Soil_Conversion\\insoils\\"
file_db = "insoils\\"
out_filename = "merged_sols_output.xlsx"

#--------------------------------------------------------------------------------------------------
 
def list_files(directory, extension):
    saved = os.getcwd()
    os.chdir(directory)
    it = glob('*.' + extension)
    os.chdir(saved)
    return it

#--------------------------------------------------------------------------------------------------
def get_mukey(a):
     with open(a,'r') as f:
        i = 0
        file = [l for l in f.readlines()] 
        mukey = int(file[7].strip().rsplit(':', 1)[-1])
        return(mukey)

#-------------------------------------------------------------------------------------------------- 
## get dictionary keys as list 
#def getList(dict): 
#    list = [] 
#    for key in dict.keys(): 
#        list.append(key) 
#          
#    return list
#--------------------------------------------------------------------------------------------------
def weighted_average(x, cols, w="depth"):
    
    '''returns weighted average across multiple columns of df '''
    return pd.Series(np.average(x[cols], weights=x[w], axis=0), cols)

#--------------------------------------------------------------------------------------------------
class SoilHorizon:
    '''Stores attributes of a single soil horizon
            Initialize attributes based on horizon dictionary
            '''
    def __init__(self,h):        
        for k, v in h.items():
            setattr(self, k, v)
    
    def __str__(self):
        return 'Horizon at {} mm'.format(self.depth)


class SoilDB:
    '''Stores soil attributes and horizon objects for a single soil file
            Instantalized with:
                desc - a short description
                s - "soil" dictionary containing general soil properties
                h - "horizons" list containing dictionaries of each horizon's properties in order of horizon depth
                b - "bedrock" dictionary containing bedrock properties   
    '''
    def __init__(self,desc,s,h,b):
        self.version = 7778
        
        self.s = s
        self.h = h
        self.b = b
        
        
        #soil parameters
        self.name = s['name']
        self.version = s['version']
        self.texture = s['texture']
        self.horizons_count = s['horizons']
        self.albedo = s['albedo']
        self.sat = s['sat']
        self.kinter = s['kinter']
        self.krill = s['krill']
        self.keff = s['keff']
        self.tauc = s['tauc']
        
        self.horizons = []
        self.depth = 0
        for hi in h:
            ha = SoilHorizon(hi)
            self.horizons.append(ha)
            self.depth = ha.depth if ha.depth > self.depth else self.depth
            
        
        
        
        #bedrock parameters#
        self.bed = b['bed']
        self.bed_id = b['bed_id']
#        self.bed_thickness = b['bed_thickness']
        self.bed_ksat = b['bed_ksat']
        
        
        
        
        self.desc = desc
        self.soil = self.update()
        
    
    
    def update(self):
        if self.version == '7778':
            soil_str ="'{name}'    '{texture}'    {horizons_count}    {albedo}    {sat}    {kinter:.2f}    {krill:.6f}    {tauc:.2f}    {keff:.2f}\n".format(**vars(self))
            for horizon in self.horizons:
                soil_str += "    {depth:.0f}    {bd}    {ksat}    {anis}    {fc}    {wp}    {sand}    {clay}    {om}    {cec}    {rocks}\n".format(**vars(horizon))                                       
            
            soil_str +="{bed}    {bed_id}    {bed_ksat}\n".format(**vars(self))
            self.soil = soil_str
            return soil_str
        
        if self.version == '2006.2':
            soil_str ="'{name}'    '{texture}'    {horizons_count}    {albedo}    {sat}    {kinter:.2f}    {krill:.6f}    {tauc:.2f}    {keff:.2f}\n".format(**vars(self))
            for horizon in self.horizons:
                soil_str += "    {depth:.0f}    {sand}    {clay}    {om}    {cec}    {rocks}\n".format(**vars(horizon))                                       
            
            soil_str +="{bed}    {bed_id}    {bed_thickness}    {bed_ksat}\n".format(**vars(self))
            self.soil = soil_str
            return soil_str
        
    def __str__(self):
        return self.update()

def readSoil(fin):
    '''Reads in a 7778 or 2006.2 version WEPP soil file and returns a Soil object
        Support for other files can be added by by adding soil, horizon, and bed key lists as noted below
    
    
        Input:  A 7778 or 2006.2 version WEPP soil file ('.sol') with one OFE
        Return: Soil Object'''
    
    
    def floatDict(d):
        for k in d.keys():
            try:
                d[k] = float(d[k])
            except:
                pass
        return d    
    
    
    with open(fin,'r') as f:
        i = 0
        file = [l for l in f.readlines() if not l.startswith("#")] #remove comments
        version = file[0].strip()
        
        #default format
        soil_key = ['name','texture','horizons','albedo','sat','kinter','krill','tauc','keff']
        horizon_key = ['depth','bd','ksat','anis','fc','wp','sand','clay','om','cec','rocks']
        bed_key = ['bed','bed_id','bed_ksat']
        
        
        if version == '7778':
            soil_key = ['name','texture','horizons','albedo','sat','kinter','krill','tauc','keff']
            horizon_key = ['depth','bd','ksat','anis','fc','wp','sand','clay','om','cec','rocks']
            bed_key = ['bed','bed_id','bed_ksat']
            
        if version == '2006.2':
            soil_key = ['name','texture','horizons','albedo','sat','kinter','krill','tauc','keff']
            horizon_key = ['depth','sand','clay','om','cec','rocks']
            bed_key = ['bed','bed_id','bed_thickness','bed_ksat']   
           
        # add file format for other versions here   
         
#        comments = file[1]
        s = floatDict(dict(zip(soil_key, shlex.split(file[3]))))
#        print(range(int(s['horizons'])))
        h = []
        for i in range(int(s['horizons'])):
            h.append(floatDict(dict(zip(horizon_key, file[4+i].split()))))
#            print(h)
            file[4+i].split()
#            print(file[4+i])
        b = floatDict(dict(zip(bed_key,file[5+i].split())))
#        print(b)
        s['version'] = version
#        print(s)
    desc = fin.strip('.sol').split('/')[-1]
#    print(desc)
    
    
    return(desc,s,h,b)


#--------------------------------------------------------------------------------------------------


soils_list = list_files(path, "sol")
print(soils_list)

fin = os.path.join(path, soils_list[1])

#--------------------------------------------------------------------------------------------------

df_horizons = []
df_soilprop = []
df_bedrockprop = []
for i in range(len(soils_list)):
    d=os.path.join(path, soils_list[i])
    desc,x,y,z = readSoil(d)
    mukey = get_mukey(d)
    y = [dict(item, **{'FileName': d.rsplit('\\', 1)[-1], 'mukey': mukey}) for item in y]
    df1= pd.DataFrame(y,columns=['depth','bd','ksat', 'anis', 'fc', 'wp', 'sand', 'clay', 'om', 'cec', 'rocks', 'FileName', 'mukey'])
    df_horizons.append(df1)
    x.update({'FileName': d.rsplit('\\', 1)[-1], 'mukey': mukey})
    df_soilprop.append(pd.DataFrame(x, index=[0]))
    z.update({'FileName': d.rsplit('\\', 1)[-1], 'mukey': mukey})
#    print(pd.DataFrame(z, index = [0]))
    df2 = pd.DataFrame(z, index=[0])
#    df2 = pd.DataFrame(x, index=[0])
    df_bedrockprop.append(df2) 

#--------------------------------------------------------------------------------------------------
horizons_df = pd.concat(df_horizons)
soilprop_df = pd.concat(df_soilprop)
bedrockprop_df = pd.concat(df_bedrockprop)

#--------------------------------------------------------------------------------------------------

depth_weighted_avg_horizons_df = horizons_df.groupby(['FileName', 'mukey']).apply(weighted_average, ['bd', 'ksat', 'anis', 'fc', 'wp', 'sand', 'clay', 'om', 'cec','rocks']).reset_index()

depth_weighted_avg_horizons_df= pd.DataFrame(depth_weighted_avg_horizons_df)

merged_df = pd.DataFrame.merge(depth_weighted_avg_horizons_df, soilprop_df, on =['FileName', 'mukey'])

merged_df.to_excel(out_filename,index=False)

















