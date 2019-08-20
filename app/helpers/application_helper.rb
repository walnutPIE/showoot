module ApplicationHelper
  def input field_name, f
    render "shared/input", field_name: field_name, f: f
  end

  def check field_name, field_title, f
    render "shared/check", field_name: field_name, field_title: field_title, f: f
  end

  def radio field_name, field_title, f, value
    render "shared/radio", field_name: field_name, field_title: field_title, f: f, value: value
  end

  def toolbar menu_list, bottom = false
    render "shared/toolbar", menu_list: menu_list, bottom: bottom
  end

  def icon icon_name
    content_tag(:i, icon_name, class: "icon material-icons")
  end

  def submit title, f
    render "shared/submit", title: title, f: f
  end

  def navback title
    render "shared/navback", title: title
  end

  def fab title, url
    render "shared/fab", title: title, url: url
  end

  # https://rubyplus.com/articles/3421-Rails-5-Blocks-in-View-
end
