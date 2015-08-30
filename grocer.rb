require 'pry'
def consolidate_cart(cart:[])
  consolidated_cart = {}
  cart.each do |item|
    food_item = item.keys[0].to_s
    consolidated_cart[food_item] ||= {}
    consolidated_cart[food_item][:count] ||= 0
    consolidated_cart[food_item][:count] += 1
    consolidated_cart[food_item].merge!(item.values[0])
  end
  consolidated_cart
end


def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
      cart["#{coupon[:item]} W/COUPON"] ||= {:price =>  coupon[:cost], :clearance => cart[coupon[:item]][:clearance]}
      cart["#{coupon[:item]} W/COUPON"][:count] ||= 0
      cart["#{coupon[:item]} W/COUPON"][:count] += 1
      cart[coupon[:item]][:count] -= coupon[:num]
      cart
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |item|
    item[1][:price] = (item[1][:price] * 0.8).round(2) if item[1][:clearance]
  end
  cart
end

def checkout(cart: [], coupons: [])
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons) if coupons
  cart = apply_clearance(cart: cart)
  cost ||= 0
  cart.each do |item|
    cost += item[1][:count] * item[1][:price]
  end
  cost > 100 ? (cost * 0.9).round(2) : cost
end
