-- Файл с Lua-фильтрами для Pandoc. Будет использоваться для docx-файлов.
-- Автор: Стрелков Н.О., <StrelkovNO@mpei.ru>

local docx_image_caption_separator = "."; -- символ разделителя между номером рисунка и его названием в docx

--[[
Функция для добавления точки в название рисунка.
Название рисунка содержится в таблице 'caption', она имеет следующий порядок элементов:

"Figure 1 Label":
1	Figure
2	nil
3	1
4	nil
5	Label

Поэтому точка должна быть добавлена к третьему элементу.
]]--
function Image(img)
  if img.title == 'fig:' and #img.caption >= 3 then
    if (FORMAT=="docx") then
      img.caption[3].text = img.caption[3].text .. docx_image_caption_separator;
      return img
    end
  end
end

--[[
Функция для добавления пустой строки текста после таблицы.
]]--
function Table(tab)
  if (FORMAT=="docx") then
    return {
      tab,
      pandoc.Para{ pandoc.Str '' }
      };
  end
end
