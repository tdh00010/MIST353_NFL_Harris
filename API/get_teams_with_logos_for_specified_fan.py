import base64

from get_db_connection import get_db_connection


def get_teams_with_logos_for_specified_fan(fan_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "{call procGetTeamsWithLogosForSpecifiedFan(?)}",
        (fan_id,)
    )

    rows = cursor.fetchall()

    results = [
        {
            "TeamName": row.TeamName,
            "Conference": row.Conference,
            "Division": row.Division,
            "TeamColor": row.TeamColor,
            "PrimaryTeam": row.PrimaryTeam,
            "TeamLogo": base64.b64encode(row.TeamLogo).decode("utf-8")
            if row.TeamLogo
            else None
        }
        for row in rows
    ]

    cursor.close()
    conn.close()

    return {"data": results}
