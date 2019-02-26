В этом репозитории расположен пример книги/отчет/диплома, созданного с помощью RMarkdown и bookdown. 

Доступные выходные форматы:

* `bookdown::gitbook` - GitBook в формате из нескольких HTML-документов;
* `bookdown::pdf_book` - книга в PDF;
* `bookdown::pdf_document2` - книга в виде PDF документа;
* `bookdown::html_document2` - книга в виде единого HTML-документа;
* `bookdown::epub_book` - книга в формате ePub;
* `bookdown::word_document2` - книга в формате docx (Microsoft Word) с учетом файла-шаблона *styles-reference.docx*.

Первоначально это был минимальный пример книги, созданной с помощью R Markdown и **bookdown** (https://github.com/rstudio/bookdown). Смотрите страницы "[Get Started](https://bookdown.org/yihui/bookdown/get-started.html)" по адресу https://bookdown.org/yihui/bookdown/ для компиляции этого примера в HTML. Вы можете сгенерировать пример этой книги в формате `bookdown::pdf_book` путем вызова `bookdown::render_book('index.Rmd', 'bookdown::pdf_book')`. Более подробные инструкции представлены здесь https://bookdown.org/yihui/bookdown/build-the-book.html.

Пример исходного англоязычного варианта представлен по адресу https://bookdown.org/yihui/bookdown-demo/.

Этот репозиторий первоначально был склонирован из https://github.com/rstudio/bookdown-demo .
