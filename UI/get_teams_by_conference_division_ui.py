import streamlit as st
from fetch_data import fetch_data

def get_teams_by_conference_division_ui():

    st.header("Get Teams by Conference and Division")

    # Inputs
    conference = st.selectbox("Select Conference", ["AFC", "NFC"])
    division = st.selectbox("Select Division", ["North", "South", "East", "West"])

    # Button
    if st.button("Get Teams"):
        params = {
            "conference": conference,
            "division": division
        }

        df = fetch_data("get_teams_by_conference_division", params)

        if not df.empty:
            st.dataframe(df)
        else:
            st.warning("No data found")