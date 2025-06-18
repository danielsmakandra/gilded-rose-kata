class GildedRose

  MINIMAL_QUALITY = 0
  MAXIMAL_QUALITY = 50

  UNCHANGING_ITEMS = [
    "Sulfuras, Hand of Ragnaros"
  ].freeze

  BRIE_NAME = /Aged Brie/.freeze
  BACKSTAGE_PASS_NAME = /Backstage passes to a TAFKAL80ETC concert/.freeze

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if UNCHANGING_ITEMS.include?(item.name)
        return
      end

      if item_is_brie?(item)
        update_brie_quality!(item)
      elsif item_is_backstage_pass?(item)
        update_backstage_pass_quality!(item)
      else
        update_normal_item_quality!(item)
      end

      item.sell_in -= 1
    end
  end

  def item_is_brie?(item)
    BRIE_NAME.match(item.name)
  end

  def update_brie_quality!(item)
    if item.sell_in <= 0
      change_quality_by!(item, 2)
    else
      change_quality_by!(item, 1)
    end
  end

  def item_is_backstage_pass?(item)
    BACKSTAGE_PASS_NAME.match(item.name)
  end

  def update_backstage_pass_quality!(item)
    if item.sell_in <= 0
      item.quality = 0
    elsif item.sell_in <= 5
      change_quality_by!(item, 3)
    elsif item.sell_in <= 10
      change_quality_by!(item, 2)
    else
      change_quality_by!(item, 1)
    end
  end

  def update_normal_item_quality!(item)
    if item.sell_in <= 0
      change_quality_by!(item, -2)
    else
      change_quality_by!(item, -1)
    end
  end

  def change_quality_by!(item, delta)
    new_quality = item.quality + delta
    item.quality = new_quality.clamp(MINIMAL_QUALITY, MAXIMAL_QUALITY)
  end
  
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name:, sell_in:, quality:)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

