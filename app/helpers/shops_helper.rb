module ShopsHelper

  def shop_link_with_name(shop)
    link_to shop.dealer_name, shop_path(shop)
  end

  def orient_dealer(shop)
    shop.orient_dealer? ?  "<span class='label label-satgreen'>Dealer</span>".html_safe : "<span class='label label-lightred'>Non Dealer</span>".html_safe
  end

  def shop_edit_link(shop)
    link_to raw("<i class='fa fa-edit'></i>"), edit_shop_path(shop), :class => 'btn', :title => 'edit'
  end

  def shop_delete_link(shop)
    link_to raw("<i class='hi hi-off'></i>"), delete_shop_path(shop), :class => 'btn', :title => 'delete', 'data-confirm' => 'are you sure?'
  end
end
