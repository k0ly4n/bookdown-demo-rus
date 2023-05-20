-- Файл с Lua-фильтрами для Pandoc. Будет использоваться для docx- и odt-файлов.
-- Автор: Стрелков Н.О., <StrelkovNO@mpei.ru>

local docx_image_caption_separator = " –"; -- символ разделителя между номером рисунка и его названием в docx
local docx_table_caption_separator = " –"; -- символ разделителя между номером таблицы и ее названием в docx
local docx_listing_caption_separator = " –"; -- символ разделителя между номером листинга и его названием в docx

local odt_image_caption_separator = " –"; -- символ разделителя между номером рисунка и его названием в odt
local odt_table_caption_separator = " –"; -- символ разделителя между номером таблицы и ее названием в odt
local odt_listing_caption_separator = " –"; -- символ разделителя между номером листинга и его названием в odt


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

local debug = false

--[[
Функция для добавления точки в название рисунка.
Название рисунка содержится в таблице 'caption', она имеет следующий порядок элементов:

"Figure 1: Label":
1	Figure
2	nil
3	1:
4	nil
5	Label

Поэтому точка должна быть добавлена к третьему элементу.
]]--
function Image(img)
  -- docx or odt
  if (FORMAT=="docx" or FORMAT=="odt") then
		if FORMAT=="docx" then
			image_caption_separator = docx_image_caption_separator;
		else
			image_caption_separator = odt_image_caption_separator;
		end

    if img.title == 'fig:' and #img.caption >= 3 then
      if debug then
        RecursiveSearch(img.caption, 1);
      end

      fig_index_idx = 3

      if img.caption[fig_index_idx].text ~= nil then
        fi3 = string.find(img.caption[fig_index_idx].text, ":")
      end
      if img.caption[fig_index_idx+1].text ~= nil then
        fi4 = string.find(img.caption[fig_index_idx+1].text, ":")

        if fi3 == nil and fi4 > 0 then
          fig_index_idx = 4
        end
      end -- исправление бага, созданного в https://github.com/rstudio/bookdown/releases/tag/v0.34

      if debug then
        print(fi3, fi4)
      end

      img.caption[fig_index_idx].text = string.gsub(img.caption[fig_index_idx].text, ':', ''); -- обход исправления бага https://github.com/rstudio/bookdown/issues/618
      img.caption[fig_index_idx].text = img.caption[fig_index_idx].text .. image_caption_separator;
      return img
    end
  end
end

--[[
Функция для изменения оформления таблицы:
1. удаление символа двоеточия (обход исправления бага https://github.com/rstudio/bookdown/issues/618) или его замена на docx_table_caption_separator / odt_table_caption_separator
2. добавление пустой строки текста после таблицы.
]]--
function Table(tab)
  -- docx or odt
  if (FORMAT=="docx" or FORMAT=="odt") then
		if FORMAT=="docx" then
			table_caption_separator = docx_table_caption_separator;
		else
			table_caption_separator = odt_table_caption_separator;
		end

    if (PANDOC_VERSION[1] >= 2) and (PANDOC_VERSION[2] < 10) then
		  if #tab.caption >= 3 then
		    tab.caption[3].text = string.gsub(tab.caption[3].text, ':', table_caption_separator);
		  end
		else
			if #tab.caption.long >= 1 then
				if #tab.caption.long[1].content >= 3 then
				  if debug then
				    RecursiveSearch(tab.caption.long[1].content, 1)
				  end

		      tab_index_idx = 3

          if tab.caption.long[1].content[tab_index_idx].text ~= nil then
            ti3 = string.find(tab.caption.long[1].content[tab_index_idx].text, ":")
          end
          if tab.caption.long[1].content[tab_index_idx+1].text ~= nil then
            ti4 = string.find(tab.caption.long[1].content[tab_index_idx+1].text, ":")

            if ti3 == nil and ti4 > 0 then
              tab_index_idx = 4
            end
          end -- исправление бага, созданного в https://github.com/rstudio/bookdown/releases/tag/v0.34

          if debug then
            print(ti3, ti4)
          end


					tab.caption.long[1].content[tab_index_idx].text = string.gsub(tab.caption.long[1].content[tab_index_idx].text, ':', table_caption_separator);
				end
			end
		end

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

function Math(m)
   if (FORMAT=="docx" or FORMAT=="odt") and m.mathtype == "DisplayMath" then
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
      number_pattern = '[(].+[)]'  -- номер
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
  -- docx or odt
  if (FORMAT=="docx" or FORMAT=="odt") then
    if FORMAT=="docx" then
      listing_caption_separator = docx_listing_caption_separator
    else
      listing_caption_separator = odt_listing_caption_separator
    end

    if d.attr.classes[1] == "example" then
      -- knitr <=1.33, bookdown <=0.21
      if type(d.content[1].content[1].content[4].text) == "string" then
          d.content[1].content[1].content[4].text = string.gsub(d.content[1].content[1].content[4].text, ':', listing_caption_separator);
      else
          -- knitr >1.33, bookdown >0.21
          if type(d.content[1].content[1].content[5].text) == "string" then
            if string.find(d.content[1].content[1].content[5].text, ':') then
              d.content[1].content[1].content[5].text = string.gsub(d.content[1].content[1].content[5].text, ':', listing_caption_separator);
            else
              d.content[1].content[1].content[5].text = d.content[1].content[1].content[5].text .. listing_caption_separator;
            end
          end
      end
      return d
    end
  end
end
