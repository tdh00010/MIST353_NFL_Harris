import streamlit as st
import requests
import pandas as pd

#Local API
#FASTAPI_URL = "http://localhost:8000"
#Azure API
FASTAPI_URL = "https://mist353-api-harris.azurewebsites.net"

def fetch_data(endpoint: str, input_params: dict = None, method: str = "GET"):
    if input_params is None:
        input_params = {}

    url = f"{FASTAPI_URL.rstrip('/')}/{endpoint.lstrip('/')}"

    try:
        if method.upper() == "GET":
            response = requests.get(url, params=input_params)

        elif method.upper() == "POST":
            response = requests.post(url, params=input_params)

        else:
            st.error(f"Unsupported method: {method}")
            return pd.DataFrame()

        if response.status_code == 200:
            payload = response.json()

            if isinstance(payload, dict) and "data" in payload:
                return pd.DataFrame(payload["data"])

            if isinstance(payload, dict):
                return pd.DataFrame([payload])

            if isinstance(payload, list):
                return pd.DataFrame(payload)

            return pd.DataFrame()

        st.error(f"Error fetching data: {response.status_code}")
        st.write(response.text)
        return pd.DataFrame()

    except requests.exceptions.RequestException as e:
        st.error(f"Connection error: {e}")
        return pd.DataFrame()
