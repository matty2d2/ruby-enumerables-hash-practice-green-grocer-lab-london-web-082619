def consolidate_cart(cart)
  hash = {}
  cart.each do |item|
    item.each do |name, price|
      if hash[name].nil?
        hash[name] = price.merge({:count => 1})
      else
        hash[name][:count] += 1
      end
    end
  end
  hash
end


def apply_coupons(cart, coupons) 
  hash = cart
  coupons.each do |coupon|
    name = coupon[:item]
    
    if hash[name] && hash[name][:count] >= coupon[:num]
      for i in 1..coupon[:num] do
        if hash["#{name} W/COUPON"] 
          hash["#{name} W/COUPON"][:count] += 1 
        else 
          hash["#{name} W/COUPON"] = {:price => coupon[:cost]/coupon[:num], 
          :clearance => hash[name][:clearance], :count => 1} 
        end 
      end
    hash[name][:count] -= coupon[:num] 
    end 
  end 
  hash 
end


def apply_clearance(cart)
  hash = cart
  hash.each do |item, attribute_hash| 
    if attribute_hash[:clearance] == true 
      attribute_hash[:price] = (attribute_hash[:price] *
      0.8).round(2) 
    end 
  end 
hash
end


def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  cart1 = apply_coupons(cart, coupons)
  cart2 = apply_clearance(cart1)

  cart2.each do |name, price_hash|
    total += price_hash[:price] * price_hash[:count]
  end
  
  if total > 100
    total = (total * 0.9)
  else
    total
  end

end
