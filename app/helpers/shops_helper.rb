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

  def post_link_with_id(post)
    link_to post.id, "/shops/#{post.shop_id}/svr/#{post.id}"
  end

  def user_link_with_image_and_name(user)
    [user_link_with_image(user), user_link_with_name(user)].join("<br>")
  end

  def user_link_with_image(user)
    link_to raw(image_tag(user.avatar.avatar(:thumb), :class => "img-circle svr-user-image")), activities_path(:user_id => user.id), :class => "user-image-link"
  end

  def user_link_with_name(user)
    link_to user.name, activities_path(:user_id => user.id), :class => "user-name-link"
  end

  def post_action_links(post)
    '<div class="btn-group btn-group-xs">' + [post_edit_link(post),post_delete_link(post)].join(" ") + '</div>'
  end

  def post_edit_link(post)
    link_to raw("<i class='fa fa-pencil'></i>"),  "/shops/#{post.shop_id}/svrs/#{post.id}/edit", :class => 'btn btn-default', "data-toggle" => "tooltip", :title=> "Update"
  end

  def post_delete_link(post)
    link_to raw("<i class='fa fa-times'></i>"),  "/shops/#{post.shop_id}/svrs/#{post.id}/delete", "data-toggle"=>"tooltip" ,:title=>"Delete", :class => 'btn btn-danger'
  end

  def post_status_dropdown(post)
    '<div class="btn-group">
      <a class="btn btn-sm btn-success dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">Change <span class="caret"></span></a>
      <ul class="dropdown-menu text-left">
        <li class='+ published_status(post) + '>' + post_published_link(post) + '</li>
        <li class='+ un_published_status(post) + '>' + post_unpublised_link(post) + '</li>
      </ul>
    </div>'
  end

  def published_status(post)
    return 'active' if post.status == 'published'
    return ''
  end

  def un_published_status(post)
    return 'active' if post.status == 'submit'
    return ''
  end

  def post_published_link(post)
    link_to "Publish", publish_report_tasks_path(:post_id => post.id)
  end

  def post_unpublised_link(post)
    link_to "Un Publish", draft_report_tasks_path(:post_id => post.id)
  end

end
