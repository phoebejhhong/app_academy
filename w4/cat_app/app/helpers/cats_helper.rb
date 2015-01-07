module CatsHelper
  def toggle_order(col)
    if col == params[:ordered_by]
      return params[:order] == "asc" ? "desc" : "asc"
    else
      return params[:order] == "desc" ? "desc" : "asc"
    end
  end
end
