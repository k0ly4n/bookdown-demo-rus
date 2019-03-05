-- Файл с Lua-фильтрами для Pandoc. Будет использоваться для docx-файлов.
-- Автор: Стрелков Н.О., <StrelkovNO@mpei.ru>

local docx_image_caption_separator = "."; -- символ разделителя между номером рисунка и его названием в docx
local docx_listing_caption_separator = "."; -- символ разделителя между номером листинга и его названием в docx

--[[
Функция для рекурсивного прохода по всем элементам блока любого типа.
Выводит древовидную структуру объектов.
]]--
local function RecursiveSearch(aTable, j)
  if type(aTable) == "table" then
    for key, value in pairs(aTable) do
      print(string.rep('\t',j), key, value)
        if(type(value) == "table") then
            RecursiveSearch(value, j + 1)
        else
            print(string.rep('\t', j + 2), key, value)
        end
    end
  else
    --print(' ',aTable)
  end
end

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

--[[
Функция для правильного выравнивания формулы с номером
формула выравнивается посередине страницы, а номер - по правому краю.

Используется совместно с пользовательским стилем, имеющем два положения табуляции:
1. по центру
2. по правому краю

]]--
local debug = false

function Math(m)
   if (FORMAT=="docx") and m.mathtype == "DisplayMath" then
      if debug then
         RecursiveSearch(m, 1);
      end

      if debug then
         print('before');
         print(m.text)
         print(m.style)
      end

      -- строки для поиска
      qquad_pattern = '\\qquad' -- разделитель формулы и номера
      number_pattern = '[(]%d+[)]'  -- номер
      full_pattern = qquad_pattern .. number_pattern; -- полный шаблон = разделитель + номер

      -- ищем полный шаблон
      qd = string.match(m.text, full_pattern)
      if debug then
         print('search: ', qd)
      end

      -- убираем полный шаблон из формулы
      m.text = string.gsub(m.text, full_pattern, '');
      if debug then
         print('replace: ', m.text)
      end

      -- если полный шаблон найден, то извлекаем номер формулы
      if qd ~= nil then
         m.mathtype = "InlineMath"; -- меняем стиль формулы на встроенный
         d = string.sub(qd, string.find(qd, number_pattern)); -- извлекаем номер формулы

         if debug then
            print('number: ', d)
         end

         return {              -- возвращаем новый формат абзаца
            pandoc.Str '\t',   -- табуляция к центру
            m,                 -- формула
            pandoc.Str '\t',   -- табуляция к правому краю
            pandoc.Str(d)      -- номер формулы
            }
      end
   end
end

--[[
Функция для добавления точки в название листинга кода (окружение example).
В промежуточном Markdown-коде содержит блок <div>...</div>.
]]--
function Div(d)
  if (FORMAT == "docx") then
    if d.attr.classes[1] == "example" then
      d.content[1].content[1].content[4].text = d.content[1].content[1].content[4].text .. docx_listing_caption_separator;
      return d
    end
  end
end
