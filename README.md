# Compute the distance between Hungarian cities and the closest point on the historical Hungarian border

## 1. Setup

You need [Anaconda](https://www.anaconda.com/products/individual) to run this project.

1. type `make setup` in your command line from this repo to create the project's virtual environment
2. run `conda activate geo_env` to activate the environment
2. run `make jupyter` to register the Ipython kernel

You should be able to run the notebook by typing
`jupyter notebook trianon_dist_example.ipynb` Also make sure you chose the right kernel by selection Kernel -> Change kernel in the notebook UI. You should have an option to select the `geo_env` kernel.

## 2. Data

The data needed to reproduce this project is not included in this repo. Go to [GISta](https://www.gistory.hu/g/hu/gistory/otka#2_Let%C3%B6lthet%C5%91%20anyagok) and download the following files from [here](https://www.gistory.hu/docs/1_MO-HOR_Shp/1_MO-HOR_Shp_EPSG3857/):
* MO_Jaras.cpg	
* MO_Jaras.csf	
* MO_Jaras.dbf	
* MO_Jaras.shp	 
* MO_Jaras.shx	
* MO_Telepules.cpg
* MO_Telepules.csf	 
* MO_Telepules.dbf	 
* MO_Telepules.shp	 
* MO_Telepules.shx	 

Then move them to the `/data` folder in this directory. Make sure to download _all_ the files, the imports won't work otherwise.

## 3. Example: distance between Pécs and the border

You can determine the distance between any Hungarian city/village and the historical (1870-1910) border by running this notebook. As an example, the following plot shows Pécs and the nearest point in the border.

    The coordinates of the city: (18.2217903805341, 46.08665705155916)
    The coordinates of the border point: (18.206553309614662, 45.78589778018612)
    The distance between Pécs and the border is 33.45 km
    
![alt text](images/Pécs.png "Pécs")

## 4. How to contribute

If you change something in the conda environment, type `make requirements` to update the list of requirements.
Before committing a notebook, put the name of the notebook in `config.conf` and type `make clean_notebook`. Now you can commit the notebook.