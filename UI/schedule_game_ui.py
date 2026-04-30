import streamlit as st
from fetch_data import fetch_data

def schedule_game_ui():
    st.header("Schedule a Game")

    home_team_id = st.text_input("Enter Home Team ID:")
    away_team_id = st.text_input("Enter Away Team ID:")
    game_round = st.text_input("Enter Game Round:", value="Wild Card")
    game_date = st.text_input("Enter Game Date (YYYY-MM-DD):", value="2026-05-31")
    game_time = st.text_input("Enter Game Time (HH:MM:SS):", value="16:00:00")
    stadium_id = st.text_input("Enter Stadium ID:", value="1")
    nfl_admin_id = st.text_input("Enter NFL Admin ID:", value="5")

    if st.button("Schedule Game"):
        if not all([home_team_id, away_team_id, game_round, game_date, game_time, stadium_id, nfl_admin_id]):
            st.error("Please fill in all fields.")
            return

        result = fetch_data(
            "schedule_game",
            {
                "home_team_id": int(home_team_id),
                "away_team_id": int(away_team_id),
                "game_round": game_round,
                "game_date": game_date,
                "game_time": game_time,
                "stadium_id": int(stadium_id),
                "nfl_admin_id": int(nfl_admin_id)
            },
            method="POST"
        )

        if result is not None and not result.empty:
            if "status_message" in result.columns:
                st.success(result["status_message"].values[0])
            else:
                st.dataframe(result, use_container_width=True, hide_index=True)
        else:
            st.success("Game scheduled successfully.")