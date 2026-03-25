from get_db_connection import get_db_connection

def get_teams_by_conference_division(
    conference: str = None,
    division: str = None
):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "{call procGetTeamsByConferenceDivision(?, ?)}",
        (conference, division)
    )

    rows = cursor.fetchall()

    results = [
        {
            "TeamName": row.TeamName,
            "Conference": row.Conference,
            "Division": row.Division,
            "TeamColor": row.TeamColor
        }
        for row in rows
    ]

    cursor.close()
    conn.close()

    return {"data": results}