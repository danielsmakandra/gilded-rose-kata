class GildedRose

  MINIMAL_QUALITY = 0
  MAXIMAL_QUALITY = 50

  UNCHANGING_ITEMS = [
    "Sulfuras, Hand of Ragnaros"
  ].freeze

  BRIE_NAME = "Aged Brie".freeze
  BACKSTAGE_PASS_NAME = "Backstage passes to a TAFKAL80ETC concert".freeze
  CONJURED_NAME = /^Conjured/.freeze

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if UNCHANGING_ITEMS.include?(item.name)
        return
      end

      case item.name
      when BRIE_NAME
        update_brie_item_quality!(item)
      when BACKSTAGE_PASS_NAME
        update_backstage_pass_item_quality!(item)
      when CONJURED_NAME
        update_conjured_item_quality!(item)
      else
        update_normal_item_quality!(item)
      end

      item.sell_in -= 1
    end
  end

  private

  def update_brie_item_quality!(item)
    if item.sell_in <= 0
      change_quality_by!(item, 2)
    else
      change_quality_by!(item, 1)
    end
  end

  def update_backstage_pass_item_quality!(item)
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

  def update_conjured_item_quality!(item)
    update_normal_item_quality!(item)
    update_normal_item_quality!(item)
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

