from flask import jsonify, Blueprint
from flask_login import current_user
from app.models.wishlist import WishlistItem
from flask import redirect, url_for

bp = Blueprint('wishlist', __name__)

@bp.route('/wishlist')
def wishlist():
    if current_user.is_authenticated:
        # Get all wishlist items for the current user
        items = WishlistItem.get_all_by_uid(current_user.id)
        return jsonify([item.__dict__ for item in items])
    return jsonify({}), 404

from app.wishlist import bp as wishlist_bp

@bp.route('/wishlist/add/<int:product_id>', methods=['POST'])
def wishlist_add(product_id):
    if current_user.is_authenticated:
        WishlistItem.add(current_user.id, product_id)
        return redirect(url_for('wishlist.wishlist'))
    return jsonify({}), 404
