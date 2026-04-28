import streamlit as st
from fetch_data import fetch_data

def validate_user_ui():
    st.header("Validate User")

    email = st.text_input("Enter Email")
    password = st.text_input("Enter Password", type="password")

    if st.button("Validate User"):
        if not email.strip():
            st.error("Please enter an email.")
            return
        if not password.strip():
            st.error("Please enter a password.")
            return

        input_params = {
            "email": email.strip(),
            "password_hash": password.strip()
        }

        df = fetch_data("validate_user", input_params)

        if df is not None and not df.empty:
            # ✅ FIXED: correct column access + correct casing
            st.session_state.app_user_id = df["AppUserID"].values[0]
            st.session_state.app_user_fullname = df["Fullname"].values[0]
            st.session_state.user_role = df["UserRole"].values[0]

            st.success(f"Welcome {st.session_state.app_user_fullname}!")
            st.subheader(f"User {email} is valid:")
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info(f"User {email} is not valid.")
