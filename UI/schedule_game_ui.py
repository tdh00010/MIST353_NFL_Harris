import streamlit as st
from fetch_data import fetch_data

def schedule_game_ui():
    st.header("Schedule a Game")

    # Require user validation
    if "app_user_id" not in st.session_state:
        st.warning("Please validate/login before scheduling a game.")
        return

    if st.session_state.get("user_role") != "NFLAdmin":
        st.error("Only NFL Admin users can schedule games.")
        return

    # Static data (you can replace with DB later if needed)
    teams = {
        "Baltimore Ravens": 1,
        "Cincinnati Bengals": 2,
        "Cleveland Browns": 3,
        "Pittsburgh Steelers": 4,
        "Houston Texans": 5,
        "Indianapolis Colts": 6,
        "Jacksonville Jaguars": 7,
        "Tennessee Titans": 8
    }

    stadiums = {
        "M&T Bank Stadium": 1,
        "Acrisure Stadium": 2,
        "Paycor Stadium": 3,
        "Cleveland Browns Stadium": 4
    }

    game_rounds = [
        "Wild Card",
        "Divisional Round",
        "Conference Championship",
        "Super Bowl"
    ]

    times = [
        "13:00:00",
        "16:00:00",
        "20:00:00"
]

    # UI Inputs
    home_team = st.selectbox("Select Home Team", list(teams.keys()))
    away_team = st.selectbox("Select Away Team", list(teams.keys()))
    stadium = st.selectbox("Select Stadium", list(stadiums.keys()))
    game_round = st.selectbox("Select Game Round", game_rounds)
    game_date = st.date_input("Select Game Date")
    game_time = st.selectbox("Select Game Start Time", times)

    # Submit
    if st.button("Schedule Game"):
        if home_team == away_team:
            st.error("Home team and away team cannot be the same.")
            return

        result = fetch_data(
            "schedule_game",
            {
                "home_team_id": teams[home_team],
                "away_team_id": teams[away_team],
                "game_round": game_round,
                "game_date": game_date.isoformat(),
                "game_time": game_time,
                "stadium_id": stadiums[stadium],
                "nfl_admin_id": st.session_state.app_user_id
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