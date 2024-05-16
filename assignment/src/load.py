from typing import Dict
from pandas import DataFrame
from sqlalchemy.engine.base import Engine
import logging

# Configurar el logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def load(data_frames: Dict[str, DataFrame], database: Engine):
    """Load the dataframes into the sqlite database.

    Args:
        data_frames (Dict[str, DataFrame]): A dictionary with keys as the table names
        and values as the dataframes.
        database (Engine): The SQLAlchemy database engine to connect to the database.
    """
    for table_name, dataframe in data_frames.items():
        try:
            # Cargar el DataFrame en la base de datos como una tabla
            logging.info(f"Loading table {table_name} into the database.")
            dataframe.to_sql(table_name, con=database, if_exists='replace', index=False)
            logging.info(f"Table {table_name} loaded successfully.")
        except Exception as e:
            logging.error(f"Error loading table {table_name}: {e}")
            # Opcional: Si deseas que el error detenga el proceso, puedes descomentar la siguiente línea
            # raise e
            # De lo contrario, el proceso continuará intentando cargar las siguientes tablas.

# Nota: Asegúrate de que el objeto `database` esté correctamente configurado antes de llamar a esta función.
