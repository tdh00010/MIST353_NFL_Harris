import streamlit as st
from fetch_data import fetch_data
import base64

def get_teams_with_logos_for_specified_fan_ui():
    st.header("Fan's Favorite Teams")

    if "app_user_id" not in st.session_state:
        st.warning("Please validate/login first.")
        return

    input_parameters = {
        "fan_id": st.session_state.app_user_id
    }

    df = fetch_data("get_teams_with_logos_for_specified_fan", input_parameters)

    if df is not None and not df.empty:
        display_name_and_userrole = f"{st.session_state.app_user_fullname} ({st.session_state.user_role})"
        st.success(f"Teams associated with {display_name_and_userrole}:")

        col1, col2, col3, col4, col5 = st.columns([1, 2, 2, 3, 1])
        col1.write("Logo")
        col2.write("Team Name")
        col3.write("Conference/Division")
        col4.write("Team Colors")
        col5.write("Primary")

        st.divider()

        for row in df.to_dict("records"):
            col1, col2, col3, col4, col5 = st.columns([1, 2, 2, 3, 1])

            with col1:
                if row["TeamLogo"]:
                    logo_bytes = base64.b64decode(row["TeamLogo"])
                    st.image(logo_bytes, width=70)
                else:
                    st.write("No logo")

            col2.write(row["TeamName"])
            col3.write(f"{row['Conference']} / {row['Division']}")
            col4.write(row["TeamColors"])
            col5.write("✅" if row["PrimaryTeam"] else "")

            st.divider()
    else:
        st.info("No teams found for the specified fan.")