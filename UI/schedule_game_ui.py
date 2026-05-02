import streamlit as st
from fetch_data import fetch_data


def build_id_lookup(data, id_column, name_column):
    if data is None or data.empty:
        return {}

    return {
        row[name_column]: int(row[id_column])
        for _, row in data.iterrows()
    }


def schedule_game_ui():
    st.header("Schedule a Game")

    # Require user validation
    if "app_user_id" not in st.session_state:
        st.warning("Please validate/login before scheduling a game.")
        return

    if st.session_state.get("user_role") != "NFLAdmin":
        st.error("Only NFL Admin users can schedule games.")
        return

    team_data = fetch_data("get_all_teams")
    stadium_data = fetch_data("get_all_stadiums")

    teams = build_id_lookup(team_data, "TeamID", "TeamName")
    stadiums = build_id_lookup(stadium_data, "StadiumID", "StadiumName")

    if not teams or not stadiums:
        st.error("Teams or stadiums could not be loaded.")
        return

    game_rounds = ["Wild Card", "Divisional", "Conference", "Super Bowl"]
    times = ["13:00:00", "16:00:00", "20:00:00"]

    # UI Inputs
    home_team = st.selectbox("Select Home Team", list(teams.keys()), index=0)
    away_team = st.selectbox("Select Away Team", list(teams.keys()), index=1)
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
