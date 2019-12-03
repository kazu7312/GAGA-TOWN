module StocksHelper
  def size_ids(hoge)
    size_ids = []
    hoge.each do |id|
      size_ids << id[:size_id]
    end
    return size_ids.sort
  end
end
