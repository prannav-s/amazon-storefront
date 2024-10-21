from flask import current_app as app

class WishlistItem:
    def __init__(self, id, uid, pid, time_added):
        self.id = id
        self.uid = uid  
        self.pid = pid  
        self.time_added = time_added  
    # fetches specific wishlist item from db by ID
    @staticmethod
    def get(id):
        rows = app.db.execute('''
SELECT id, uid, pid, time_purchased
FROM Purchases
WHERE id = :id
''',
                              id=id)
        return WishlistItem(*(rows[0])) if rows else None
    
    # retrieves all wishlist items for user
    @staticmethod
    def get_all_by_uid(uid):
        rows = app.db.execute('''
SELECT id, uid, pid, time_added
FROM Wishes
WHERE uid = :uid
ORDER BY time_added DESC
''', uid=uid)
        return [WishlistItem(*row) for row in rows]

    
    @staticmethod
    def add(uid, pid):
        try:
            rows = app.db.execute('''
INSERT INTO Wishes (uid, pid, time_added)
VALUES (:uid, :pid, current_timestamp)
RETURNING id
''', uid=uid, pid=pid)
            return rows[0][0]  
        except Exception as e:
            print(str(e))
            return None
#do later
    @staticmethod
    def remove(id):
        try:
            app.db.execute('''
DELETE FROM Wishes
WHERE id = :id
''', id=id)
        except Exception as e:
            print(str(e))
