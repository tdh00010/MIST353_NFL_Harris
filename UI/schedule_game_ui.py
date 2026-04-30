import streamlit as st
from fetch_data import fetch_data

def schedule_game_ui():
    st.header("Schedule a Game")

    home_team_id = st.text_input("Enter Home Team ID: ")
    away_team_id = st.text_input("Enter Away Team ID: ")
    game_round = st.text_input("Enter Game Round (e.g., Regular Season, Playoffs): ")
    game_date = st.text_input("Enter Game Date (YYYY-MM-DD): ")
    game_time = st.text_input("Enter Game Time (HH:MM:SS): ")
    stadium_id = st.text_input("Enter Stadium ID: ")
    nfl_admin_id = st.text_input("Enter NFL Admin ID: ")

    if st.button("Schedule Game"):
        result = fetch_data(
            "schedule_game",
            {
                "home_team_id": home_team_id,
                "away_team_id": away_team_id,
                "game_round": game_round,
                "game_date": game_date,
                "game_time": game_time,
                "stadium_id": stadium_id,
                "nfl_admin_id": nfl_admin_id
            },
            method="POST"
        )

        st.write(result)