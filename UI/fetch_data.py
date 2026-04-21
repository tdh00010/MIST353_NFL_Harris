import streamlit as st
import requests
import pandas as pd

#FASTAPI_URL = "http://localhost:8000"
FASTAPI_URL = "https://mist353-api-harris.azurewebsites.net/"

def fetch_data(endpoint: str, input_params: dict, method: str = "GET"):
    if method == "GET":
        response = requests.get(f"{FASTAPI_URL}/{endpoint}", params=input_params)

        if response.status_code == 200:
            payload = response.json()
            rows = payload.get("data", [])
            df = pd.DataFrame(rows)
            return df
        else:
            st.error(f"Error fetching data: {response.status_code}")
            return pd.DataFrame()  # Return an empty DataFrame on error
            