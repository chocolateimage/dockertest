import os
from flask import Flask, g, request
import psycopg
import psycopg.rows

is_prod = os.environ.get("PROD","FALSE") == "TRUE"
app = Flask(__name__)

conn = psycopg.connect(
    host="db",
    user=os.environ.get("POSTGRES_USER"),
    password=os.environ.get("POSTGRES_PASSWORD"),
    dbname=os.environ.get("POSTGRES_DB"),
)

def get_cursor() -> psycopg.Cursor:
    cursor = g.get("cursor", None)
    if cursor != None:
        return cursor

    cursor = conn.cursor(row_factory=psycopg.rows.dict_row)

    setattr(g, "cursor", cursor)

    return cursor

@app.post("/api/data")
def api_data():
    data = "This is some data"
    if is_prod:
        data += " (This is the API telling you that this is prod)"
    return data

@app.post("/api/posts/list")
def api_posts_list():
    cursor = get_cursor()

    posts = []

    for post in cursor.execute("SELECT * FROM posts ORDER BY time DESC").fetchall():
        posts.append({
            "id": post["id"],
            "name": post["name"],
            "content": post["content"]
        })

    return {
        "posts": posts
    }

@app.post("/api/posts/add")
def api_posts_add():
    name = request.json.get("name", "")
    content = request.json.get("content", "")

    cursor = get_cursor()

    post = cursor.execute("INSERT INTO posts (name, content, time) VALUES (%s, %s, NOW()) RETURNING id", (
        name,
        content
    )).fetchone()
    conn.commit()

    return {
        "id": post["id"],
        "name": name,
        "content": content
    }

if __name__ == "__main__":
    app.run(debug=not is_prod,host="0.0.0.0",port=8081)