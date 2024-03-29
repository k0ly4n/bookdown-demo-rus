# Введение

В этом репозитории расположен пример книги/отчета/диплома, созданного с помощью RMarkdown и bookdown (https://github.com/rstudio/bookdown).

# Список файлов и каталогов, их назначение и содержание

Основой репозитория служат файлы с расширением `*.Rmd` - это RMarkdown-документы, содержащие различные части работы, они включаются в результирующий документ в алфавитном порядке начиная с `index.Rmd`.

Полный список файлов и каталогов представлен в таблице ниже:

| Имя  | Назначение и содержание |
| --------- | ----------------------- |
| `/figures` | Папка для иллюстраций |
| `index.Rmd` | Основной документ, содержит *аннотацию* и настройки в формате YAML преамбулы |
| `00-intro.Rmd` | *Введение* |
| `01-chapter.Rmd` | *Глава 1* |
| `02-chapter.Rmd` | *Глава 2* |
| `03-chapter.Rmd` | *Глава 3* |
| `60-conclusion.Rmd` | *Заключение* |
| `90-appendix.Rmd` | *Приложения* |
| `99-references.Rmd` | *Список использованных источников* (создается автоматически, по сути содержит только заголовок) |
| `bibliography.bib` | Список библиографических ссылок в формате [BibTeX](https://ru.wikipedia.org/wiki/BibTeX) |
| `bookdown-demo-rus.Rproj` | Файл проекта для RStudio |
| `_bookdown.yml` | Настройки для bookdown документа в формате YAML (имя выходного файла, подписи рисунков, таблиц и листингов) |
| `_build.sh` | Скрипт компиляции выходных документов |
| `filter.lua` | Файл Lua-фильтра для Pandoc, служит для автоматического редактирования docx- и odt- документов приблеженно к ГОСТ |
| `format.eqp` | Файл с настройками форматирования формул MathType |
| `format.md` | Файл с требованиями к офомлению с соответствии с документом *Metodika_vkr.pdf* |
| `.gitlab-ci.yml` | Файл в формате YAML с правилами автоматической сборки для GitLab CI/CD |
| `gost-r-7-0-5-2008-numeric.csl` | Файл CSL-стиля для  формирования списка литературы по ГОСТ |
| `README.md` | Этот документ |
| `styles-reference.docx` | Шаблон документа MS Word со стилями оформления |
| `styles-reference.odt` | Шаблон документа OpenDocument (LibreOffice.org Writer) со стилями оформления |
| `TODO.md` | Файл TODO со списком задач, требующих решения |
| `install-remark.sh` | Скрипт установки remark-linter, служащего для проверки синтаксиса Markdown |
| `rule.rb` | Конфигурационный файл для mdl |
| `run-mdl.sh` | Скрипт для запуска [mdl](https://snapcraft.io/mdl) |
| `run-remark.sh` | Скрипт для запуска [remark-linter](https://www.npmjs.com/package/remark-lint) |
| `.remarkrc` | Конфигурационный файл для remark-linter |

**Примечание**: после клонирования этого репозитория и запуска компиляции документа в программе RStudio с помощью кнопки *Build All* в списке файлов появятся следующие элементы:

* файл `bookdown-demo-rus.html` - книга в виде единого HTML-документа (соответствует формату  `bookdown::html_document2`);
* папка `_book` со следующими файлами:
  * `bookdown-demo-rus.docx` - книга в формате docx (Microsoft Word) с учетом файла-шаблона *styles-reference.docx* (**в случае подготовки дипломов, отчетов и пособий это основной выходной формат** `bookdown::word_document2` );
  * `bookdown-demo-rus.epub`  - книга в формате ePub (формат `bookdown::epub_book`);
  * `bookdown-demo-rus.odt` - книга в формате OpenDocument (LibreOffice.org Writer) с учетом файла-шаблона *styles-reference.odt* (*альфа-версия*, формат `bookdown::odt_document2`);
  * несколько `*.html` файлов, папка с иллюстрациями `figures`, папка  `libs` с библиотеками на языке JavaScript - книга в формате GitBook (`bookdown::gitbook`);
  * `bookdown-demo-rus.pdf` и `bookdown-demo-rus.tex`  книга в PDF (формат `bookdown::pdf_book`) и соответствующий промежуточный LaTeX документ.

# Быстрый старт

Возможно два варианта работы с этим репозиторием - полностью локальный (автономный) и упрощенный сетевой.

В обоих вариантах работы иллюстрации должны быть подготовлены локально и сохранены в папке `figures` и помещены под контроль версий.

## Локальный вариант работы

В случае локального варианта работы на локальный компьютер следует установить большое количество программного обеспечения:

1. [Git](https://git-scm.com/download) для клонирования этого репозитория. Опционально выполняется установка редактора [Notepad++](https://notepad-plus-plus.org/download/)  и программы сравнения ревизий [WinMerge](http://winmerge.org/) или [Meld](http://meldmerge.org/).
1. Язык программирования [R](https://cran.r-project.org/bin/windows/base/old/4.0.5/R-4.0.5-win.exe), [R for Windows Build Tools](https://cran.r-project.org/bin/windows/Rtools/rtools40-x86_64.exe), [RStudio](https://www.rstudio.com/products/rstudio/download/#download) и набор типографских программ [TeXLive](https://www.tug.org/texlive/acquire-iso.html#torrent) (около 8 Гб при полной установке) для создания выходных документов (можно не устанавливать, если не требуется поддержка PDF-формата).
1. Markdown редактор ([ReText](https://github.com/retext-project/retext) или [Typora](https://typora.io)) для редактирования Rmd-документов.

    > **Примечание**: полная инструкция по установке необходимого набора программ представлена в документе [`01-chapter.Rmd`](01-chapter.Rmd) в разделе *Необходимое программное обеспечение*.

Все изменения документов должны быть зафиксированы в системе Git и отправлены на сервер GitLab для хранения.

## Сетевой вариант работы

В случае сетевого варианта работы на локальном компьютере выполняется редактирование текстовых файлов, а компиляция выходных документов выполняется на сервере GitLab. При этом список программного обеспечения для локальной установки существенно сокращается до следующих позиций:

1. [Git](https://git-scm.com/download) для клонирования этого репозитория. Опционально выполняется установка редактора [Notepad++](https://notepad-plus-plus.org/download/)  и программы сравнения ревизий [WinMerge](http://winmerge.org/) или [Meld](http://meldmerge.org/).
1. Markdown редактор ([ReText](https://github.com/retext-project/retext) или [Typora](https://typora.io)) для редактирования Rmd-документов.

    > **Примечание**: инструкция по установке редактора ReText представлена в документе [`01-chapter.Rmd`](01-chapter.Rmd) в разделе *Необходимое программное обеспечение*.

Все изменения документов должны быть зафиксированы в системе Git и отправлены на сервер GitLab для компиляции и хранения.

