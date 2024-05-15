from typing import Dict
import requests
from pandas import DataFrame, read_csv, to_datetime

def get_public_holidays(public_holidays_url: str, year: str) -> DataFrame:
    """Get the public holidays for the given year for Brazil.

    Args:
        public_holidays_url (str): URL to the public holidays.
        year (str): The year to get the public holidays for.

    Raises:
        SystemExit: If the request fails.

    Returns:
        DataFrame: A dataframe with the public holidays.
    """
    try:
        # Obtener los datos desde la URL
        response = requests.get(f"{public_holidays_url}/{year}/BR")
        response.raise_for_status()  # Lanza un error si la solicitud no fue exitosa
    except requests.exceptions.RequestException as e:
        print(f"Request failed: {e}")
        raise SystemExit(e)

    # Convertir la respuesta a JSON
    holidays_data = response.json()

    # Convertir los datos a un DataFrame de pandas
    df = DataFrame(holidays_data)

    # Procesar el DataFrame: eliminar columnas no deseadas, convertir tipos de datos, etc.
    if 'types' in df.columns:
        df.drop(columns=['types'], inplace=True)
    if 'counties' in df.columns:
        df.drop(columns['counties'], inplace=True)
    if 'date' in df.columns:
        df['date'] = to_datetime(df['date'])

    return df

def extract(
    csv_folder: str, csv_table_mapping: Dict[str, str], public_holidays_url: str
) -> Dict[str, DataFrame]:
    """Extract the data from the csv files and load them into the dataframes.

    Args:
        csv_folder (str): The path to the csv's folder.
        csv_table_mapping (Dict[str, str]): The mapping of the csv file names to the table names.
        public_holidays_url (str): The url to the public holidays.

    Returns:
        Dict[str, DataFrame]: A dictionary with keys as the table names and values as the dataframes.
    """
    # Leer los archivos CSV y convertirlos en DataFrames
    dataframes = {
        table_name: read_csv(f"{csv_folder}/{csv_file}")
        for csv_file, table_name in csv_table_mapping.items()
    }

    # Obtener los datos de los días festivos públicos
    holidays = get_public_holidays(public_holidays_url, "2017")

    # Añadir los datos de los días festivos públicos al diccionario de DataFrames
    dataframes["public_holidays"] = holidays

    return dataframes
