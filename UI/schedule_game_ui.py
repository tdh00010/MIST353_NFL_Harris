import streamlit as st
from fetch_data import fetch_data


def build_id_lookup(data, id_column, name_column):
    if data is None or data.empty:
        return {}

    return {
        row[name_column]: int(row[id_column])
        for _, row in data.iterrows()
    }


def validate_admin_for_scheduling():
    st.info("Validate as an NFL Admin to schedule a game.")

    email = st.text_input("Admin Email", key="schedule_admin_email")
    password = st.text_input("Admin Password", type="password", key="schedule_admin_password")

    if st.button("Validate Admin", key="schedule_validate_admin"):
        if not email.strip() or not password.strip():
            st.error("Please enter both email and password.")
            return

        result = fetch_data(
            "validate_user",
            {
                "email": email.strip(),
                "password_hash": password.strip()
            }
        )

        if result is None or result.empty:
            st.error("Admin user is not valid.")
            return

        user_role = result["UserRole"].values[0]

        if user_role != "NFLAdmin":
            st.error("This user is valid, but is not an NFL Admin.")
            return

        st.session_state.app_user_id = result["AppUserID"].values[0]
        st.session_state.app_user_fullname = result["Fullname"].values[0]
        st.session_state.user_role = user_role
        st.rerun()


def schedule_game_ui():
    st.header("Schedule a Game")

    # Require user validation
    if "app_user_id" not in st.session_state:
        validate_admin_for_scheduling()
        return

    if st.session_state.get("user_role") != "NFLAdmin":
        current_user = st.session_state.get("app_user_fullname", "Current user")
        current_role = st.session_state.get("user_role", "Unknown role")
        st.warning(f"{current_user} is logged in as {current_role}. Only NFL Admin users can schedule games.")
        validate_admin_for_scheduling()
        return

    st.caption(f"Scheduling as {st.session_state.app_user_fullname}")

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
