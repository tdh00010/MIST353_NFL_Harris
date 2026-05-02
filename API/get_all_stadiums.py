from get_db_connection import get_db_connection

def get_all_stadiums():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("{call procGetAllStadiums}")
    rows = cursor.fetchall()

    results = [
        {
            "StadiumID": row.StadiumID,
            "StadiumName": row.StadiumName
        }
        for row in rows
    ]

    cursor.close()
    conn.close()

    return {"data": results}