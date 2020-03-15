module ProductsHelper

  def image1_url(product)
    if product.image1.blank?
      "https://dummyimage.com/200x200/000/fff"
    else
      "/images/#{product.image1}"
    end
  end
  
  def image2_url(product)
    if product.image2.blank?
      "https://dummyimage.com/200x200/000/fff"
    else
      "/images/#{product.image2}"
    end
  end
  
  def image3_url(product)
    if product.image3.blank?
      "https://dummyimage.com/200x200/000/fff"
    else
      "/images/#{product.image3}"
    end
  end
end