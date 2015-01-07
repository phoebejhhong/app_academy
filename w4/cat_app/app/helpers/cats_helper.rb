module CatsHelper
  def toggle_order(col)
    if col == params[:ordered_by]
      params[:order] == "asc" ? "desc" : "asc"
    else
      params[:order] == "desc" ? "desc" : "asc"
    end
  end
end
