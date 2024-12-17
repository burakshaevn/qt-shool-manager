# Управление базой данных школы — School Manager

## Описание
Приложение разработано на C++17 с использованием фреймворка Qt 6.6.3 и базы данных PostgreSQL. Проект представляет собой систему для управления данными о школе, включая преподавателей, учеников, предметы, расписание и другие компоненты образовательного процесса. Данные извлекаются из PostgreSQL, обрабатываются и отображаются в удобном интерфейсе с использованием Qt.

## Пример
<table>
  <tr>
    <td>
      <figure>
        <img src="https://github.com/user-attachments/assets/ca115ef7-2b0a-4081-a4b8-3a4b825eee81" alt="Image 1">
        <figcaption>Рис. 1 — Окно авторизации.</figcaption>
      </figure>
    </td>
    <td>
      <figure>
        <img src="https://github.com/user-attachments/assets/661dc7df-7c78-4b83-b25e-b9e45b93dab3" alt="Image 2">
        <figcaption>Рис. 2 — Вывод таблицы из базы данных.</figcaption>
      </figure>
    </td>
  </tr>
</table>

Управление записями таблиц происходит с помощью кнопок «Add», «Edit» и «Delete». Кнопка «Logout» — выход из текущего аккаунта.

### Добавление записи
При нажатии на кнопку добавления новой записи «Add», происходит вызов функции `void Table::AddRecord();`, которая создаёт экземпляр класса, в котором строится диалоговое окно `EditDialog dialog(newRecord, this);`, где `newRecord` — передача конкретной записи из базы данных в виде QSqlRecord. Эта запись используется для отображения столбцов таблицы.
<div align="center">
  <img src="https://github.com/user-attachments/assets/ae4a39c6-78df-4996-b511-f116185459ed" alt="image">
  <p>Рис. 3 — Окно ввода новых данных для текущей таблицы (teachers).</p>
</div>

<div align="center">
  <img src="https://github.com/user-attachments/assets/6a9d8311-e6f2-45a0-87ab-a14c7e569f15" alt="image">
  <p>Рис. 4 — Окно ввода новых данных для текущей таблицы (classes).</p>
</div>

### Удаление записи
Производится ввод ID записи в таблице. Она будет удалена.

В некоторых таблицах, например, ID начинается необязательно с 1. Итерироваться в этом окне мы можем от самого минимального ID до самого максимального. Чтобы не выходить за пределы.
<div align="center">
  <img src="https://github.com/user-attachments/assets/a3b3e4f2-aa02-4b36-83c0-fb953ccb189e" alt="image">
  <p>Рис. 5 — Окно ввода ID записи (автоинкрементируемого столбца) в текущей таблице.</p>
</div>

После указания ID удаляемой записи выходит окно подтверждения удаления, где строится таблица с удаляемой строкой (чтобы быть уверенным, что удаляется именно то, что мы задумали).
<div align="center">
  <img src="https://github.com/user-attachments/assets/c2254c07-7f3c-49ff-a899-b3141b379543" alt="image">
  <p>Рис. 6 — Вывод удаляемой строки.</p>
</div>

<div align="center">
  <img src="https://github.com/user-attachments/assets/bf66e036-a05d-48cb-a64a-5b911e22aef6" alt="image">
  <p>Рис. 7 — Окно подтверждения удаления.</p>
</div>

После подтверждения происходит удаление из основной таблицы, а записи, которые ссылались на первичный ключ этой строки, зануляются (NULL).

### Редактирование записи
Для редактирования указывается всегда номер строки в таблицы, а не ID записи. 
<div align="center">
  <img src="https://github.com/user-attachments/assets/b44792b7-1329-4303-8a26-cb23624892cf" alt="image">
  <p>Рис. 8 — Окно поиска записи в таблице.</p>
</div>

<div align="center">
  <img src="https://github.com/user-attachments/assets/fadc13b9-992c-4505-bb05-d54e899186a4" alt="image">
  <p>Рис. 9 — Окно редактирования записи.</p>
</div>

После кнопки «Save» происходит обновление данных в текущей строке текущей таблицы и каскадное обновление зависимых строк в зависимых таблицах благодаря триггерным функциям.

## ER-диаграмма базы данных
<div align="center">
  <img src="https://github.com/user-attachments/assets/6288c4bf-fcb0-43c2-b951-170d5391d71e" alt="image">
  <p>Рис. 10 — ER-диаграмма.</p>
</div> 
