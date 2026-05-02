from get_db_connection import get_db_connection

def insert_logos():
    teams = [
        "Baltimore Ravens",
        "Cincinnati Bengals",
        "Cleveland Browns",
        "Pittsburgh Steelers",
        "New England Patriots",
        "Tampa Bay Buccaneers"
    ]

    conn = get_db_connection()
    cursor = conn.cursor()

    for team in teams:
        filepath = f"TeamLogos/{team.replace(' ', '_')}.png"

        with open(filepath, "rb") as image_file:
            logo_data = image_file.read()

        cursor.execute(
            "UPDATE Team SET TeamLogo = ? WHERE TeamName = ?",
            (logo_data, team)
        )

    conn.commit()
    cursor.close()
    conn.close()

    print("Logos inserted successfully.")

if __name__ == "__main__":
    insert_logos()