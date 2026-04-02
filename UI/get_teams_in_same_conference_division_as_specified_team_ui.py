import streamlit as st
from fetch_data import fetch_data

def get_teams_in_same_conference_division_as_specified_team_ui():
    st.header("Get Teams in Same Conference and Division as Specified Team")

    team_name = st.text_input("Enter Team Name")

    if st.button("Fetch Teams", key="same_division_button"):
        if not team_name.strip():
            st.warning("Please enter a team name")
        else:
            input_params = {
                "team_name": team_name.strip()
            }

            df = fetch_data("get_teams_in_same_conference_division_as_specified_team", input_params)

            if df is not None and not df.empty:
                st.subheader(f"Teams in the Same Conference and Division as {team_name}:")
                st.dataframe(df, use_container_width=True, hide_index=True)
            else:
                st.info(f"No teams found for {team_name}. Check spelling.")