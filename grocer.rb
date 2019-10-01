require 'pry'

def consolidate_cart(cart)
  counting_cart = { }
  cart.each do |item|
    specific_item = item.keys[0]
    if counting_cart[specific_item]
      counting_cart[specific_item][:count] += 1 
    else 
      counting_cart[specific_item] = item[specific_item]
      counting_cart[specific_item][:count] = 1
    end
  end
  return counting_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    coupon_item = "#{item} W/COUPON"
    if cart.has_key?(item)
      if cart[item][:count] >= coupon[:num] 
        cart[coupon_item] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
        cart[item][:count] -= coupon[:num]
      else
        cart[coupon_item][:count] += coupon[:num]
        cart[item][:count] -= coupon[:num]
      end
    end
   end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |product_name, stats|
    stats[:price] -= stats[:price] * 0.2 if stats[:clearance] 
  end
  cart
end

def checkout(array, coupons)
  hash_cart = consolidate_cart(array)
  applied_coupons = apply_coupons(hash_cart, coupons)
  applied_discount = apply_clearance(applied_coupons)
  total = applied_discount.reduce(0) { |acc, (key, value)| acc += value[:price] * value[:count]}
  total > 100 ? total * 0.9 : total 
end
