```python
import geopandas as gpd
import os
import pyproj
import matplotlib.pyplot as plt
from shapely.geometry import MultiPoint
from shapely.ops import cascaded_union, nearest_points
```

# Compute the distance between Hungarian cities and the closest point on the historical Hungarian border

## 0. Data 

Data source: [GISta](https://www.gistory.hu/g/hu/gistory/otka#2_Let%C3%B6lthet%C5%91%20anyagok)

We need 2 datasets:  
        1. the point coordinates of the border   
        2. the coordinates of the cities  
    
(1) has to be created from county-level maps.

## 1. Recreate the border from county-level (járás) maps


```python
jaras = gpd.read_file("data/MO_Jaras.shp")
```

### Original polygons (jaras szintu)


```python
jaras.plot()
plt.title('Járások, 1870-1910 borders')
```




    Text(0.5, 1.0, 'Járások, 1870-1910 borders')




![png](trianon_dist_example_files/trianon_dist_example_8_1.png)


### Create a single polygon


```python
polygons = jaras.geometry.values
border = gpd.GeoSeries(cascaded_union(polygons))
```


```python
border
```




    0    POLYGON ((2504923.596 5618647.256, 2504926.103...
    dtype: geometry




```python
border.plot()
plt.title('Single polygon, 1870-1910 borders')
```




    Text(0.5, 1.0, 'Single polygon, 1870-1910 borders')




![png](trianon_dist_example_files/trianon_dist_example_12_1.png)


### Create a list of points from the polygon


```python
border_points = border.copy()
border_points = border_points.geometry.apply(lambda x: MultiPoint(list(x.exterior.coords)))
```


```python
border_points.plot()
plt.title('Borders 1870-1910')
```




    Text(0.5, 1.0, 'Borders 1870-1910')




![png](trianon_dist_example_files/trianon_dist_example_15_1.png)



```python
border
```




    0    POLYGON ((2504923.596 5618647.256, 2504926.103...
    dtype: geometry




```python
border_points
```




    0    MULTIPOINT (2504923.596 5618647.256, 2504926.1...
    dtype: geometry



## 2. Bring in the city-level data!


```python
telepules = gpd.read_file("data/MO_Telepules.shp")
```

Originally, cities are polygons (below you can see Pécs), we want to get the central point so we can compute the distance


```python
telepules.iloc[0].geometry
```




![svg](trianon_dist_example_files/trianon_dist_example_21_0.svg)



The next cell computes the centorid for each city. After this operation, we'll have a single point per city.


```python
telepules
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>telepulesn</th>
      <th>status</th>
      <th>JaraszSzek</th>
      <th>MegyeSzekh</th>
      <th>IDJaras</th>
      <th>IDJGeo</th>
      <th>IDMegye</th>
      <th>Nev_megj</th>
      <th>IDTel1910</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Pécs</td>
      <td>tjv.</td>
      <td>T</td>
      <td>T</td>
      <td>M0100001</td>
      <td>M0104</td>
      <td>M01</td>
      <td>None</td>
      <td>M0100001</td>
      <td>POLYGON ((2031533.098 5802031.448, 2031529.808...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Albertfalu</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M0101</td>
      <td>M0101</td>
      <td>M01</td>
      <td>None</td>
      <td>M0101001</td>
      <td>POLYGON ((2087951.529 5730866.087, 2087904.908...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Baranyabán</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M0101</td>
      <td>M0101</td>
      <td>M01</td>
      <td>None</td>
      <td>M0101002</td>
      <td>POLYGON ((2075914.329 5759798.947, 2076115.517...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Baranyaszentistván</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M0101</td>
      <td>M0101</td>
      <td>M01</td>
      <td>None</td>
      <td>M0101003</td>
      <td>POLYGON ((2064136.420 5743787.374, 2064182.642...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Baranyavár</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M0101</td>
      <td>M0101</td>
      <td>M01</td>
      <td>None</td>
      <td>M0101004</td>
      <td>POLYGON ((2076479.239 5744532.547, 2076368.017...</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>12617</th>
      <td>None</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M2704</td>
      <td>M2704</td>
      <td>M27</td>
      <td>None</td>
      <td>X83</td>
      <td>POLYGON ((2089467.889 6026080.272, 2089449.881...</td>
    </tr>
    <tr>
      <th>12618</th>
      <td>None</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M1906</td>
      <td>M1906</td>
      <td>M19</td>
      <td>None</td>
      <td>X85</td>
      <td>POLYGON ((1922499.229 6123885.890, 1922424.304...</td>
    </tr>
    <tr>
      <th>12619</th>
      <td>None</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M1502</td>
      <td>M1502</td>
      <td>M15</td>
      <td>None</td>
      <td>X86</td>
      <td>POLYGON ((2145237.916 6127566.078, 2145263.662...</td>
    </tr>
    <tr>
      <th>12620</th>
      <td>None</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M0907</td>
      <td>M0907</td>
      <td>M09</td>
      <td>None</td>
      <td>X87</td>
      <td>POLYGON ((1899959.959 5981083.157, 1900008.839...</td>
    </tr>
    <tr>
      <th>12621</th>
      <td>Németcsernye</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M4814</td>
      <td>M4814</td>
      <td>M48</td>
      <td>None</td>
      <td>M4814012</td>
      <td>POLYGON ((2301700.796 5723173.772, 2301591.140...</td>
    </tr>
  </tbody>
</table>
<p>12622 rows × 10 columns</p>
</div>




```python
telepules['centers'] = telepules['geometry'].centroid
```


```python
telepules
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>telepulesn</th>
      <th>status</th>
      <th>JaraszSzek</th>
      <th>MegyeSzekh</th>
      <th>IDJaras</th>
      <th>IDJGeo</th>
      <th>IDMegye</th>
      <th>Nev_megj</th>
      <th>IDTel1910</th>
      <th>geometry</th>
      <th>centers</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Pécs</td>
      <td>tjv.</td>
      <td>T</td>
      <td>T</td>
      <td>M0100001</td>
      <td>M0104</td>
      <td>M01</td>
      <td>None</td>
      <td>M0100001</td>
      <td>POLYGON ((2031533.098 5802031.448, 2031529.808...</td>
      <td>POINT (2028440.427 5794246.965)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Albertfalu</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M0101</td>
      <td>M0101</td>
      <td>M01</td>
      <td>None</td>
      <td>M0101001</td>
      <td>POLYGON ((2087951.529 5730866.087, 2087904.908...</td>
      <td>POINT (2084605.382 5733324.333)</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Baranyabán</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M0101</td>
      <td>M0101</td>
      <td>M01</td>
      <td>None</td>
      <td>M0101002</td>
      <td>POLYGON ((2075914.329 5759798.947, 2076115.517...</td>
      <td>POINT (2076465.052 5752384.712)</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Baranyaszentistván</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M0101</td>
      <td>M0101</td>
      <td>M01</td>
      <td>None</td>
      <td>M0101003</td>
      <td>POLYGON ((2064136.420 5743787.374, 2064182.642...</td>
      <td>POINT (2061616.977 5742233.893)</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Baranyavár</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M0101</td>
      <td>M0101</td>
      <td>M01</td>
      <td>None</td>
      <td>M0101004</td>
      <td>POLYGON ((2076479.239 5744532.547, 2076368.017...</td>
      <td>POINT (2071441.352 5748051.223)</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>12617</th>
      <td>None</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M2704</td>
      <td>M2704</td>
      <td>M27</td>
      <td>None</td>
      <td>X83</td>
      <td>POLYGON ((2089467.889 6026080.272, 2089449.881...</td>
      <td>POINT (2087328.036 6024598.613)</td>
    </tr>
    <tr>
      <th>12618</th>
      <td>None</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M1906</td>
      <td>M1906</td>
      <td>M19</td>
      <td>None</td>
      <td>X85</td>
      <td>POLYGON ((1922499.229 6123885.890, 1922424.304...</td>
      <td>POINT (1919573.205 6122821.018)</td>
    </tr>
    <tr>
      <th>12619</th>
      <td>None</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M1502</td>
      <td>M1502</td>
      <td>M15</td>
      <td>None</td>
      <td>X86</td>
      <td>POLYGON ((2145237.916 6127566.078, 2145263.662...</td>
      <td>POINT (2144013.806 6126460.563)</td>
    </tr>
    <tr>
      <th>12620</th>
      <td>None</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M0907</td>
      <td>M0907</td>
      <td>M09</td>
      <td>None</td>
      <td>X87</td>
      <td>POLYGON ((1899959.959 5981083.157, 1900008.839...</td>
      <td>POINT (1899092.176 5980693.658)</td>
    </tr>
    <tr>
      <th>12621</th>
      <td>Németcsernye</td>
      <td>None</td>
      <td>F</td>
      <td>F</td>
      <td>M4814</td>
      <td>M4814</td>
      <td>M48</td>
      <td>None</td>
      <td>M4814012</td>
      <td>POLYGON ((2301700.796 5723173.772, 2301591.140...</td>
      <td>POINT (2303666.482 5733306.505)</td>
    </tr>
  </tbody>
</table>
<p>12622 rows × 11 columns</p>
</div>




```python
telepules[telepules.MegyeSzekh == 'T'].centers.plot()
plt.title('Megyeszékhelyek')
```




    Text(0.5, 1.0, 'Megyeszékhelyek')




![png](trianon_dist_example_files/trianon_dist_example_26_1.png)


## 3. Find nearest points


```python
def get_distance(a,b):
    """function computing the distance (km) between 2 pairs of coordinates"""
    a_x, a_y = a.x, a.y
    b_x, b_y = b.x, b.y
    geod = pyproj.Geod(ellps='WGS84')
    angle1,angle2,distance = geod.inv(a_x,a_y,b_x,b_y)
    return distance/1000
```


```python
border_geom = gpd.GeoDataFrame(
    geometry = gpd.points_from_xy([pt.x for pt in border_points[0]], [pt.y for pt in border_points[0]])
)

unioned_points = border_geom.geometry.unary_union
```


```python
# first, we find the nearest point on the border
telepules['nearest'] = telepules.apply(lambda row: nearest_points(row.centers, unioned_points)[1], axis=1)

# next, we project the points from Web Mercator / Pseudo Mercator ("EPSG:3857") to WGS84 (World Geodetic System 1984, EPSG:4326, this one is used in the GPSs
telepules['nearest'] = gpd.GeoDataFrame(telepules[['nearest']], geometry='nearest').set_crs("EPSG:3857").to_crs("EPSG:4326")
telepules['centers'] =  gpd.GeoDataFrame(telepules[['centers']], geometry='centers').set_crs("EPSG:3857").to_crs("EPSG:4326")

# now we can easily compute the distance
telepules['distance'] = telepules.apply(lambda row: get_distance(row.centers, row.nearest), axis=1)
```

The distance between the cities and the borders is in the `distance` column of the dataframe.

## 4. Test the output

The function `plot_city_nearest` takes a city name as argument and displays the border with black, the location of the city with red and the nearest point on the border with green. The small map it outputs helps to check if the calculations were correct. You can also check the points on google maps to validate.


```python
def plot_city_nearest(city, border_data=border_points, cities_data=telepules, save=True):
    
    filt_df = cities_data[cities_data.telepulesn == city]
    ind = cities_data.index[cities_data.telepulesn == city].tolist()[0]
    
    print('The coordinates of the city: {}'.format(cities_data.iloc[ind]['centers'].coords[0]))
    print('The coordinates of the border point: {}'.format(cities_data.iloc[ind]['nearest'].coords[0]))
    print('The distance between {} and the border is {:0.2f} km'.format(city, cities_data.iloc[ind]['distance']))
    
    ax = border_points.set_crs("EPSG:3857").to_crs("EPSG:4326").plot(
        color='white', edgecolor='black')

    gpd.GeoDataFrame(filt_df[['centers']], geometry='centers').set_crs("EPSG:4326").plot(ax=ax, color='red')

    gpd.GeoDataFrame(filt_df[['nearest']], geometry='nearest').set_crs("EPSG:4326").plot(ax=ax, color='green')

    plt.show()
    
    if save:
        plt.savefig('data/{}.png'.format(city))
```


```python
plot_city_nearest('Pécs')
```

    The coordinates of the city: (18.2217903805341, 46.08665705155916)
    The coordinates of the border point: (18.206553309614662, 45.78589778018612)
    The distance between Pécs and the border is 33.45 km



![png](trianon_dist_example_files/trianon_dist_example_35_1.png)



    <Figure size 432x288 with 0 Axes>



```python
plot_city_nearest('Budapest')
```

    The coordinates of the city: (19.058772853850645, 47.50478108117815)
    The coordinates of the border point: (17.06980792274492, 48.11904645364168)
    The distance between Budapest and the border is 163.87 km



![png](trianon_dist_example_files/trianon_dist_example_36_1.png)



    <Figure size 432x288 with 0 Axes>


That's all, have fun!


```python
plot_city_nearest('Győr')
```

    The coordinates of the city: (17.62781984711149, 47.67160212647922)
    The coordinates of the border point: (16.983109160166766, 48.02455543883455)
    The distance between Győr and the border is 62.20 km



![png](trianon_dist_example_files/trianon_dist_example_38_1.png)



    <Figure size 432x288 with 0 Axes>



```python
plot_city_nearest('Sátoraljaújhely')
```

    The coordinates of the city: (21.65458805517711, 48.38303057257215)
    The coordinates of the border point: (22.221159257031815, 49.1625468620638)
    The distance between Sátoraljaújhely and the border is 96.17 km



![png](trianon_dist_example_files/trianon_dist_example_39_1.png)



    <Figure size 432x288 with 0 Axes>



```python

```
