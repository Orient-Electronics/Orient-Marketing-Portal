module ApplicationHelper

  def year_weeks
    t = Date.today
    b = t.beginning_of_year
    beginning = b.beginning_of_week
    ending = t.end_of_year
    a = []
    i = 1
    until beginning > ending
      end_of_week = beginning + 6.days
      if i==1
        a.push(["#{i.ordinalize + ' week - ' + b.strftime('%d') + b.strftime('%b') + '-' +  end_of_week.strftime('%d') + end_of_week.strftime('%b')}" , i])
      else
        a.push(["#{i.ordinalize + ' week - ' + beginning.strftime('%d') + beginning.strftime('%b') + '-' + end_of_week.strftime('%d') + end_of_week.strftime('%b')}" , i])
      end
      beginning = end_of_week + 1.days
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

  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end    
      else
        html << "<h5>#{message}</h5>"
      end  
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end  
end
