module ApplicationHelper

  def year_weeks
    t = Date.today
    b = t.beginning_of_year
    beginning = b.beginning_of_week
    ending = t.end_of_year
    a = []
    i = 1
    until beginning > ending
      end_of_week = beginning + 5.days
      if i==1
        a.push(["#{i.ordinalize + ' week - ' + b.strftime('%b')}" , i])
      else
        a.push(["#{i.ordinalize + ' week - ' + beginning.strftime('%b')}" , i])
      end
      beginning = end_of_week + 2.days
      i +=1
    end
    return a
  end

  def get_brand_name(id)
      brand = Brand.find(id)
      name  = brand.name 
  end
  
  def get_productcategory_name(id)
    category = ProductCategory.find(id)
    category.name
  end
end
